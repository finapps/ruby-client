module FinApps
  module REST
    class Categories < FinApps::REST::Resources
      include FinApps::REST::Defaults

      # @return [Array<Hash>, Array<String>]
      def list
        end_point = Defaults::END_POINTS[:categories_list]
        logger.debug "##{__method__.to_s} => end_point: #{end_point}"

        path = end_point
        logger.debug "##{__method__.to_s} => path: #{path}"

<<<<<<< HEAD
        categories, error_messages = @client.send(path, :get)
=======
        categories, error_messages = @client.send_request(path, :get)

        logger.debug "##{__method__.to_s} => Completed"
>>>>>>> develop
        return categories, error_messages
      end

    end
  end
end
