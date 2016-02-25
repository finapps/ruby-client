module FinApps
  module REST

    require 'erb'

    class BudgetCalculation < FinApps::REST::Resources
      include FinApps::REST::Defaults

      # @param [String] budget_model_id
      # @param [Number] income
      # @return [Array<Hash>, Array<String>]
      def create(budget_model_id, income)
        raise MissingArgumentsError.new 'Missing argument: budget_model_id.' if budget_model_id.blank?
        logger.debug "##{__method__.to_s} => budget_model: #{budget_model_id}"

        raise MissingArgumentsError.new 'Missing argument: income.' if income.blank?
        logger.debug "##{__method__.to_s} => income: #{income}"

        end_point = Defaults::END_POINTS[:budget_calculation_create]
        logger.debug "##{__method__.to_s} => end_point: #{end_point}"

        path = end_point.sub(':budget_model_id', ERB::Util.url_encode(budget_model_id)).sub(':income', ERB::Util.url_encode(income))
        logger.debug "##{__method__.to_s} => path: #{path}"

        budget_calculation, error_messages = @client.send(path, :get)
        return budget_calculation, error_messages
      end

      # @return [Array<Hash>, Array<String>]
      def show
        end_point = Defaults::END_POINTS[:budget_calculation_show]
        logger.debug "##{__method__.to_s} => end_point: #{end_point}"

        path = end_point
        logger.debug "##{__method__.to_s} => path: #{path}"

        budget_calculation, error_messages = @client.send(path, :get)
        return budget_calculation, error_messages
      end

    end
  end
end