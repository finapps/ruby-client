module FinApps
  module REST

    require 'erb'

    class Transactions < FinApps::REST::Resources
      include FinApps::REST::Defaults

      # @param [Hash] params
      # @return [Array<FinApps::REST::Transaction>, Array<String>]
      def search(params={})
        logger.debug "##{__method__.to_s} => Started"

        path = Defaults::END_POINTS[:transactions_search]
        logger.debug "##{__method__.to_s} => path: #{path}"

        transactions, error_messages = @client.send(path, :post, params.compact) do |r|
          r.body.transactions.each { |i| Transaction.new(i) }
        end

        logger.debug "##{__method__.to_s} => Completed"
        return transactions, error_messages
      end

    end

    class Transaction < FinApps::REST::Resource
      attr_accessor :_id, :account_id, :date, :transaction_date, :description, :amount,
                    :type, :status, :keyword, :merchant_name, :categories, :tags
    end

  end
end