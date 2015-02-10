module FinApps
  module REST

    require 'erb'

    class Cashflows < FinApps::REST::Resources
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

        cashflow = Cashflow.new({:start_date => start_date,
                                 :end_date => end_date,
                                 :total_income_amount => 0,
                                 :total_expenses_amount => 0,
                                 :total_leftover_amount => 0,
                                 :details => []})

        end_point = Defaults::END_POINTS[:cashflow_show]
        logger.debug "##{__method__.to_s} => end_point: #{end_point}"

        path = end_point.sub(':start_date', ERB::Util.url_encode(start_date)).sub(':end_date', ERB::Util.url_encode(end_date))
        logger.debug "##{__method__.to_s} => path: #{path}"

        result, error_messages = @client.send(path, :get)
        if result.present? && error_messages.blank?

          summary = extract_value(result, 'summary')
          raise 'Summary result-set for cashflow is not present.' if summary.nil?
          raise 'Summary result-set for cashflow is not a hash.' unless summary.respond_to?(:key?)

          raise 'Total income (inflow) value for cashflow is not present.' unless summary.key?('inflow')
          cashflow.total_income_amount = summary['inflow']

          raise 'Total expenses (outflow) value for cashflow is not present.' unless summary.key?('outflow')
          cashflow.total_expenses_amount = summary['outflow']

          raise 'Total left-over (diff) value for cashflow is not present.' unless summary.key?('diff')
          cashflow.total_leftover_amount = summary['diff']

          categories = extract_value(result, 'details')
          raise 'Category results-set for cashflow is not an array.' unless categories.respond_to?(:each)

          categories.each { |category| cashflow.details << result_category_to_cashflow_detail(category) }
        end

        logger.debug "##{__method__.to_s} => Completed"
        return cashflow, error_messages
      end

      private

      def extract_value(result, array_identifier)
        array_container = result.find { |r| r.has_key?(array_identifier) }
        array_container.present? ? array_container[array_identifier] : nil
      end

      def result_category_to_cashflow_detail(category)
        raise 'Unable to locate category id for current category record.' unless category.key?('cat')
        raise 'Unable to locate inflow amount for current category record.' unless category.key?('inflow')
        raise 'Unable to locate outflow amount for current category record.' unless category.key?('outflow')
        raise 'Unable to locate left over amount for current category record.' unless category.key?('diff')

        CashflowDetail.new({:category_id => category['cat'],
                            :income_amount => category['inflow'],
                            :expenses_amount => category['outflow'],
                            :leftover_amount => category['diff']})
      end

    end

    class Cashflow < FinApps::REST::Resource
      attr_accessor :start_date, :end_date,
                    :total_income_amount, :total_expenses_amount, :total_leftover_amount, :details
    end

    class CashflowDetail < FinApps::REST::Resource
      attr_accessor :category_id, :income_amount, :expenses_amount, :leftover_amount
    end

  end
end