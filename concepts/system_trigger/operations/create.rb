require 'securerandom'

class SystemTrigger
  class Create < Trailblazer::Operation
    extend Contract::DSL

    step Model(Trigger, :new)
    step Contract::Build()
    step Contract::Validate()
    step :set_timestamps
    step :set_type
    step Contract::Persist()
    step :log_success
    failure  :log_failure

    contract do
      property :title
      property :key
      property :output

      validation do
        configure do
          config.messages_file = 'config/error_messages.yml'

          def unique_key?(value)
            Trigger.where(key: value).where(device_id: nil).first.nil?
          end
        end

        required(:title).filled
        required(:key).filled
        rule(key: [:key]) do |key|
          key.filled?.then(key.unique_key?)
        end
      end
    end

    def set_timestamps(options, model:, **)
      timestamp = Time.now
      model.created_at = timestamp
      model.updated_at = timestamp
    end

    def set_type(options, model:, **)
      model.type = Trigger::Types['system']
    end

    def log_success(options, params:, model:, **)
      LOGGER.info "[#{self.class}] Created system trigger with params #{params.to_json}. Trigger: #{Trigger::Representer.new(model).to_json}"
    end

    def log_failure(options, params:, **)
      LOGGER.info "[#{self.class}] Failed to create system trigger with params #{params.to_json}"
    end
  end
end