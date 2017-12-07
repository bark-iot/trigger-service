class Trigger < Sequel::Model(DB)
  class List < Trailblazer::Operation
    extend Contract::DSL

    step Contract::Build()
    step Contract::Validate()
    step :list_by_device_id
    failure  :log_failure

    contract do
      property :device_id, virtual: true

      validation do
        required(:device_id).filled
      end
    end

    def list_by_device_id(options, params:, **)
      options['models'] = Trigger.where(device_id: params[:device_id]).all
      options['models']
    end

    def log_success(options, params:, model:, **)
      LOGGER.info "[#{self.class}] Found triggers for device #{params.to_json}. Triggers: #{Trigger::Representer.new(options['model']).to_json}"
    end

    def log_failure(options, params:, **)
      LOGGER.info "[#{self.class}] Failed to find triggers with params #{params.to_json}"
    end
  end
end