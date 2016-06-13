module FinApps
  module REST

    class Transactions < FinApps::REST::Resources
      include FinApps::REST::Defaults

      # @transaction_id [String]
      # # @return [Hash, Array<String>]
      def show(transaction_id)
        end_point = Defaults::END_POINTS[:transactions_show]
        logger.debug "##{__method__.to_s} => end_point: #{end_point}"

        path = end_point.sub ':transaction_id', ERB::Util.url_encode(transaction_id)
        logger.debug "##{__method__.to_s} => path: #{path}"

<<<<<<< HEAD
        transaction, error_messages = @client.send(path, :get)
=======
        transaction, error_messages =  @client.send_request(path, :get)

        logger.debug "##{__method__.to_s} => Completed"
>>>>>>> develop
        return transaction, error_messages
      end

      # @param [Hash] params
      # @return [Array<Hash>, Array<String>]
      def search(params={})
        path = Defaults::END_POINTS[:transactions_list]
        logger.debug "##{__method__.to_s} => path: #{path}"

<<<<<<< HEAD
        transactions, error_messages = @client.send(path, :post, params.compact)
=======
        transactions, error_messages = @client.send_request(path, :post, params.compact)

        logger.debug "##{__method__.to_s} => Completed"
>>>>>>> develop
        return transactions, error_messages
      end

      # @param [Hash] params
      # @return [Array<Hash>, Array<String>]
      def update(params={})
        path = Defaults::END_POINTS[:transactions_update]
        logger.debug "##{__method__.to_s} => path: #{path}"

<<<<<<< HEAD
        _, error_messages = @client.send(path, :put, params.compact)
=======
        _, error_messages = @client.send_request(path, :put, params.compact)

        logger.debug "##{__method__.to_s} => Completed"
>>>>>>> develop
        error_messages
      end

    end

  end
end
