require 'securerandom'

class Trigger < Sequel::Model(DB)
  class Create < Trailblazer::Operation
    extend Contract::DSL

    step Model(Trigger, :new)
    step Contract::Build()
    step Contract::Validate()
    step :set_timestamps
    step Contract::Persist()
    step :log_success
    failure  :log_failure

    contract do
      property :device_id
      property :title
      property :key
      property :output

      validation do
        configure do
          config.messages_file = 'config/error_messages.yml'
          option :form

          def unique_key?(value)
            Trigger.where(key: value).where(device_id: form.device_id).first.nil?
          end
        end

        required(:device_id).filled
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

    def log_success(options, params:, model:, **)
      LOGGER.info "[#{self.class}] Created trigger with params #{params.to_json}. Trigger: #{Trigger::Representer.new(model).to_json}"
    end

    def log_failure(options, params:, **)
      LOGGER.info "[#{self.class}] Failed to create trigger with params #{params.to_json}"
    end
  end
end