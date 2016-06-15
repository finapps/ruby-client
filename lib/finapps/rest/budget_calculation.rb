module FinApps
  module REST

    require 'erb'

    class BudgetCalculation < FinApps::REST::Resources
      include FinApps::REST::Defaults

      # Creates a new Budget Calculation for the given user, using a budget template
      # matching budget_model_id and teh given income amount.
      # @param [String] budget_model_id
      # @param [Number] income
      # @return [Array<Hash>, Array<String>]
      def create(budget_model_id, income)
        raise MissingArgumentsError.new 'Missing argument: budget_model_id.' if budget_model_id.blank?
        logger.debug "##{__method__} => budget_model: #{budget_model_id}"
        raise MissingArgumentsError.new 'Missing argument: income.' if income.blank?
        logger.debug "##{__method__} => income: #{income}"

        end_point = Defaults::END_POINTS[:budget_calculation_create]
        logger.debug "##{__method__} => end_point: #{end_point}"

        path = end_point.sub(':budget_model_id', ERB::Util.url_encode(budget_model_id)).sub(':income', ERB::Util.url_encode(income))
        logger.debug "##{__method__} => path: #{path}"

        budget_calculation, error_messages = client.send_request(path, :get)
        return budget_calculation, error_messages
      end

      # Shows the Budget Calculation for the given user.
      # @return [Array<Hash>, Array<String>]
      def show
        end_point = Defaults::END_POINTS[:budget_calculation_show]
        logger.debug "##{__method__} => end_point: #{end_point}"

        path = end_point
        logger.debug "##{__method__} => path: #{path}"

        budget_calculation, error_messages = client.send_request(path, :get)
        return budget_calculation, error_messages
      end

    end
  end
end