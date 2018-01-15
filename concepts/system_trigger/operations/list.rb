class SystemTrigger
  class List < Trailblazer::Operation
    step :list_by_type
    failure  :log_failure

    def list_by_type(options, params:, **)
      options['models'] = Trigger.where(type: Trigger::Types['system']).all
      options['models']
    end

    def log_success(options, params:, model:, **)
      LOGGER.info "[#{self.class}] Found system triggers for device #{params.to_json}. Triggers: #{Trigger::Representer.for_collection.new(result['models']).to_json}"
    end

    def log_failure(options, params:, **)
      LOGGER.info "[#{self.class}] Failed to find system triggers with params #{params.to_json}"
    end
  end
end