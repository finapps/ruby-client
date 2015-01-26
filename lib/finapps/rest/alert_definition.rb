module FinApps
  module REST

    require 'erb'

    class AlertDefinition < FinApps::REST::Resources
      include FinApps::REST::Defaults

      # @return [Hash, Array<String>]
      def list
        logger.debug "##{__method__.to_s} => Started"

        end_point = Defaults::END_POINTS[:alert_definition_list]
        logger.debug "##{__method__.to_s} => end_point: #{end_point}"

        path = end_point
        logger.debug "##{__method__.to_s} => path: #{path}"

        budget, error_messages = @client.send(path, :get)

        logger.debug "##{__method__.to_s} => Completed"
        return budget, error_messages
      end

    end
  end
end