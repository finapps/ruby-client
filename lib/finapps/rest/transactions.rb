module FinApps
  module REST

    class Transactions < FinApps::REST::Resources
      include FinApps::REST::Defaults

      # @param [Hash] params
      # @return [Array<FinApps::REST::Transaction>, Array<String>]
      def search(params={})
        logger.debug "##{__method__.to_s} => Started"

        path = Defaults::END_POINTS[:transactions_search]

        logger.debug "##{__method__.to_s} => path: #{path}"

        transactions, error_messages = @client.send(path, :post, params.compact)

        logger.debug "##{__method__.to_s} => Completed"
        return transactions, error_messages
      end

    end

  end
end