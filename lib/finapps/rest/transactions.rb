module FinApps
  module REST

    class Transactions < FinApps::REST::Resources
      include FinApps::REST::Defaults

      # @transaction_id [String]
      # # @return [Hash, Array<String>]
      def search_by_id(transaction_id)
        logger.debug "##{__method__.to_s} => Started"

        transactions, error_messages =  search_by_ids([transaction_id])

        # get one
        transaction = transactions.present? ? transactions.first : nil

        logger.debug "##{__method__.to_s} => Completed"
        return transaction, error_messages
      end

      # @transaction_ids [Array<String>]
      # # @return [Array<Hash>, Array<String>]
      def search_by_ids(transaction_ids)
        logger.debug "##{__method__.to_s} => Started"

        transactions, error_messages = search

        # filter by given ids
        transactions = transactions.present? ? transactions.select { |t| transaction_ids.include?(t[:_id]) } : nil

        logger.debug "##{__method__.to_s} => Completed"
        return transactions, error_messages
      end


      # @param [Hash] params
      # @return [Array<Hash>, Array<String>]
      def search(params={})
        logger.debug "##{__method__.to_s} => Started"

        path = Defaults::END_POINTS[:transactions_list]

        logger.debug "##{__method__.to_s} => path: #{path}"

        transactions, error_messages = @client.send(path, :post, params.compact)

        logger.debug "##{__method__.to_s} => Completed"
        return transactions, error_messages
      end

      # @param [Hash] params
      # @return [Array<Hash>, Array<String>]
      def edit(params={})
        logger.debug "##{__method__.to_s} => Started"

        path = Defaults::END_POINTS[:transactions_list]

        logger.debug "##{__method__.to_s} => path: #{path}"

        transactions, error_messages = @client.send(path, :put, params.compact)

        logger.debug "##{__method__.to_s} => Completed"
        return transactions, error_messages
      end

    end

  end
end