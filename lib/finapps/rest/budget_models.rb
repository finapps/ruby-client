module FinApps
  module REST

    require 'erb'

    class BudgetModels < FinApps::REST::Resources
      include FinApps::REST::Defaults

      # Lists all budget models.
      # @return [Array<Hash>, Array<String>]
      def list
        path = Defaults::END_POINTS[:budget_models_list]
        logger.debug "##{__method__} => path: #{path}"

        budget_models, error_messages = client.send_request(path, :get)
        return budget_models, error_messages
      end

      # Shows a budget model matching a given budget_model_id
      # @param [Integer] budget_model_id
      def show(budget_model_id)
        raise MissingArgumentsError.new 'Missing argument: budget_model_id.' if budget_model_id.blank?
        logger.debug "##{__method__} => budget_model_id: #{budget_model_id}"

        end_point = Defaults::END_POINTS[:budget_models_show]
        logger.debug "##{__method__} => end_point: #{end_point}"

        path = end_point.sub ':budget_model_id', ERB::Util.url_encode(budget_model_id)
        logger.debug "##{__method__} => path: #{path}"

        budget_model, error_messages = client.send_request(path, :get) { |r| BudgetModel.new(r.body) }
        return budget_model, error_messages
      end

    end

    class BudgetModel < FinApps::REST::Resource
      attr_accessor :_id, :name, :desc
    end

  end
end