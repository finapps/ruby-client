module FinApps
  module REST
    class Categories < FinApps::REST::Resources
      include FinApps::REST::Defaults

      # Lists all categories.
      # @return [Array<Hash>, Array<String>]
      def list
        end_point = Defaults::END_POINTS[:categories_list]
        logger.debug "##{__method__.to_s} => end_point: #{end_point}"

        path = end_point
        logger.debug "##{__method__.to_s} => path: #{path}"

        categories, error_messages = client.send_request(path, :get)
        return categories, error_messages
      end

    end
  end
end