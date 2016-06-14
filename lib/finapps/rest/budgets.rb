module FinApps
  module REST

    require 'erb'

    class Budgets < FinApps::REST::Resources
      include FinApps::REST::Defaults

      # Shows budget results for a given date range.
      # @param [Date] start_date
      # @param [Date] end_date
      # @return [Hash, Array<String>]
      def show(start_date, end_date)
        raise MissingArgumentsError.new 'Missing argument: start_date.' if start_date.blank?
        logger.debug "##{__method__.to_s} => start_date: #{start_date}"
        raise MissingArgumentsError.new 'Missing argument: end_date.' if end_date.blank?
        logger.debug "##{__method__.to_s} => end_date: #{end_date}"

        budget = Budget.new({:start_date => start_date, :end_date => end_date, :details => []})

        end_point = Defaults::END_POINTS[:budget_show]
        logger.debug "##{__method__.to_s} => end_point: #{end_point}"

        path = end_point.sub(':start_date', ERB::Util.url_encode(start_date)).sub(':end_date', ERB::Util.url_encode(end_date))
        logger.debug "##{__method__.to_s} => path: #{path}"

        result, error_messages = @client.send_request(path, :get)
        if result.present? && error_messages.blank?
          categories = result_categories(result)
          raise 'Category results-set for budget is not an array.' unless categories.respond_to?(:each)

          transactions = result_transactions(result)
          categories.each { |category| budget.details << result_category_to_budget_detail(category, transactions) }
        end

        return budget, error_messages
      end

      # Updates the budget parameters.
      # @param [Hash] params
      # @return [Array<Hash>, Array<String>]
      def update(params={})
        raise MissingArgumentsError.new 'Missing argument: params.' if params.blank?

        end_point = Defaults::END_POINTS[:budget_update]
        logger.debug "##{__method__.to_s} => end_point: #{end_point}"

        budget, error_messages = @client.send_request(end_point, :put, params)
        return budget, error_messages
      end

      private

      def result_categories(result)
        extract_array(result, 'cats')
      end

      def result_category_to_budget_detail(category, transactions)
        raise 'Unable to locate category id for current category record.' unless category.key?('cat_id')
        category_id = category['cat_id']

        raise 'Unable to locate category name for current category record.' unless category.key?('name')
        category_name = category['name']

        raise 'Unable to locate budget_amount for current category record.' unless category.key?('budget_amount')
        budget_amount = category['budget_amount']

        BudgetDetail.new({:category_id => category_id,
                          :category_name => category_name,
                          :budget_amount => budget_amount,
                          :expense_amount => expense_amount(category_id, transactions)})
      end

      def result_transactions(result)
        extract_array(result, 'trans')
      end

      def extract_array(result, array_identifier)
        array_container = result.find { |r| r.has_key?(array_identifier) }
        array_container.present? ? array_container[array_identifier] : nil
      end

      def expense_amount(category_id, transactions = [])
        amount = 0
        if category_id.present? && transactions.respond_to?(:find)
          transaction = transactions.find { |t| t['category_id'] == category_id }
          amount = transaction['expense_amount'].to_f if transaction.present? && transaction.key?('expense_amount')
        end
        amount
      end

    end

    class Budget < FinApps::REST::Resource
      attr_accessor :start_date, :end_date, :details
    end

    class BudgetDetail < FinApps::REST::Resource
      attr_accessor :category_id, :category_name, :budget_amount, :expense_amount
    end

  end
end