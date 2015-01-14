module FinApps
  module REST

    class Transactions < FinApps::REST::Resources
      include FinApps::REST::Defaults

      # @transaction_id [String]
      # # @return [Hash, Array<String>]
      def show(transaction_id)
        logger.debug "##{__method__.to_s} => Started"

        end_point = Defaults::END_POINTS[:transactions_show]
        logger.debug "##{__method__.to_s} => end_point: #{end_point}"

        path = end_point.sub ':transaction_id', ERB::Util.url_encode(transaction_id)
        logger.debug "##{__method__.to_s} => path: #{path}"

        transaction, error_messages =  @client.send(path, :get)

        logger.debug "##{__method__.to_s} => Completed"
        return transaction, error_messages
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
      def update(params={})
        logger.debug "##{__method__.to_s} => Started"

        path = Defaults::END_POINTS[:transactions_update]
        logger.debug "##{__method__.to_s} => path: #{path}"

        _, error_messages = @client.send(path, :put, params.compact)

        logger.debug "##{__method__.to_s} => Completed"
        error_messages
      end

    end

  end
end