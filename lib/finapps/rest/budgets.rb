module FinApps
  module REST

    require 'erb'

    class Budgets < FinApps::REST::Resources
      include FinApps::REST::Defaults

      # @param [Date] start_date
      # @param [Date] end_date
      # @return [Hash, Array<String>]
      def show(start_date, end_date)
        logger.debug "##{__method__.to_s} => Started"

        raise MissingArgumentsError.new 'Missing argument: start_date.' if start_date.blank?
        logger.debug "##{__method__.to_s} => start_date: #{start_date}"
        raise MissingArgumentsError.new 'Missing argument: end_date.' if end_date.blank?
        logger.debug "##{__method__.to_s} => end_date: #{end_date}"

        budget = Budget.new({:start_date => start_date, :end_date => end_date, :details => []})

        end_point = Defaults::END_POINTS[:budget_show]
        logger.debug "##{__method__.to_s} => end_point: #{end_point}"

        path = end_point.sub(':start_date', ERB::Util.url_encode(start_date)).sub(':end_date', ERB::Util.url_encode(end_date))
        logger.debug "##{__method__.to_s} => path: #{path}"

        result, error_messages = @client.send(path, :get)
        if result.present? && error_messages.blank?
          transactions = result.find { |r| r.has_key?('trans') }
          categories = result.find { |r| r.has_key?('cats') }

          raise 'Category results set for budget is not an array.' unless categories.respond_to?(:each)
          categories['cats'].each do |c|

            raise 'Unable to locate category id for current category record.' unless c.key?['cat_id']
            category_id = c['cat_id']

            raise 'Unable to locate budget_amount for current category record.' unless c.key?['budget_amount'] && c.key?['days']
            raise 'Unable to locate number of days for current category record.' unless c.key?['days']
            budget_amount = c['budget_amount'].to_f * c['days'].to_i

            raise 'Unable to locate category name for current category record.' unless c.key?['name']
            category_name = c['name']

            budget.details << BudgetDetail.new({:category_id => category_id,
                                                :category_name => category_name,
                                                :budget_amount => budget_amount,
                                                :expense_amount => expense_amount(category_id, transactions)})
          end
        end


        logger.debug "##{__method__.to_s} => Completed"
        return budget, error_messages
      end

      # @param [Hash] params
      # @return [Array<Hash>, Array<String>]
      def update(params={})
        logger.debug "##{__method__.to_s} => Started"

        raise MissingArgumentsError.new 'Missing argument: params.' if params.blank?

        end_point = Defaults::END_POINTS[:budget_update]
        logger.debug "##{__method__.to_s} => end_point: #{end_point}"

        budget, error_messages = @client.send(end_point, :put, params)
        logger.debug "##{__method__.to_s} => Completed"

        return budget, error_messages
      end

      private
      def expense_amount(category_id, transactions)
        amount = 0
        if category_id.present? && transactions.respond_to?(:find)
          transaction = transactions.find { |t| t['category_id'] == category_id }
          if transaction.present? && transaction.key?['expense']
            amount = transaction['expense'].to_f
          end
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