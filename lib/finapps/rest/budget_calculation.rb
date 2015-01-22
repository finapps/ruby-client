module FinApps
  module REST

    require 'erb'

    class BudgetCalculation < FinApps::REST::Resources
      include FinApps::REST::Defaults

      # @param [Hash] params
      # @return [Array<Hash>, Array<String>]
      def create_old(params = {})
        logger.debug "##{__method__.to_s} => Started"

        raise MissingArgumentsError.new 'Missing argument: params.' if params.blank?

        end_point = Defaults::END_POINTS[:budget_calculation_create]
        logger.debug "##{__method__.to_s} => end_point: #{end_point}"

        path = end_point
        logger.debug "##{__method__.to_s} => path: #{path}"

        budget_calculation, error_messages = @client.send(path, :post)
        logger.debug "##{__method__.to_s} => Completed"

        return budget_calculation, error_messages
      end

      # @param [String] budget_model
      # @param [Number] income
      # @return [Array<Hash>, Array<String>]
      def create(budget_model, income)
        logger.debug "##{__method__.to_s} => Started"

        raise MissingArgumentsError.new 'Missing argument: budget_model.' if budget_model.blank?
        logger.debug "##{__method__.to_s} => budget_model: #{budget_model}"
        raise MissingArgumentsError.new 'Missing argument: income.' if income.blank?
        logger.debug "##{__method__.to_s} => income: #{income}"

        end_point = Defaults::END_POINTS[:budget_calculation_create]
        logger.debug "##{__method__.to_s} => end_point: #{end_point}"

        path = end_point.sub(':budget_model', ERB::Util.url_encode(budget_model)).sub(':income', ERB::Util.url_encode(income))
        logger.debug "##{__method__.to_s} => path: #{path}"

        budget_calculation, error_messages = @client.send(path, :get)
        logger.debug "##{__method__.to_s} => Completed"

        return budget_calculation, error_messages
      end

      # @return [Array<Hash>, Array<String>]
      def show
        logger.debug "##{__method__.to_s} => Started"

        end_point = Defaults::END_POINTS[:budget_calculation_show]
        logger.debug "##{__method__.to_s} => end_point: #{end_point}"

        path = end_point
        logger.debug "##{__method__.to_s} => path: #{path}"

        budget_calculation, error_messages = @client.send(path, :get)
        logger.debug "##{__method__.to_s} => Completed"

        return budget_calculation, error_messages
      end

    end
  end
end