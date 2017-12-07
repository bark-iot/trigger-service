require 'securerandom'

class Trigger < Sequel::Model(DB)
  class Delete < Trailblazer::Operation
    extend Contract::DSL

    step Contract::Build()
    step Contract::Validate()
    step :delete
    step :log_success
    failure  :log_failure

    contract do
      property :id, virtual: true
      property :device_id, virtual: true

      validation do
        required(:id).filled
        required(:device_id).filled
      end
    end

    def delete(options, params:, **)
      options['model'] = Trigger.where(id: params[:id]).where(device_id: params[:device_id]).first
      return false unless options['model']
      options['model'].destroy
    end

    def log_success(options, params:, **)
      LOGGER.info "[#{self.class}] Deleted trigger with params #{params.to_json}."
    end

    def log_failure(options, params:, **)
      LOGGER.info "[#{self.class}] Failed to delete trigger with params #{params.to_json}"
    end
  end
end