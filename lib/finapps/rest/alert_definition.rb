module FinApps
  module REST

    require 'erb'

    class AlertDefinition < FinApps::REST::Resources
      include FinApps::REST::Defaults

      # @return [Hash, Array<String>]
      def list
        end_point = Defaults::END_POINTS[:alert_definition_list]
        logger.debug "##{__method__.to_s} => end_point: #{end_point}"

        path = end_point
        logger.debug "##{__method__.to_s} => path: #{path}"

<<<<<<< HEAD
        result, error_messages = @client.send(path, :get)
=======
        result, error_messages = @client.send_request(path, :get)

        logger.debug "##{__method__.to_s} => Completed"
>>>>>>> develop
        return result, error_messages
      end

      # @return [Hash, Array<String>]
      def show(alert_name)
        raise MissingArgumentsError.new 'Missing argument: alert_name.' if alert_name.blank?
        logger.debug "##{__method__.to_s} => alert_name: #{alert_name}"

        end_point = Defaults::END_POINTS[:alert_definition_show]
        logger.debug "##{__method__.to_s} => end_point: #{end_point}"

        path = end_point.sub ':alert_name', ERB::Util.url_encode(alert_name)
        logger.debug "##{__method__.to_s} => path: #{path}"

<<<<<<< HEAD
        result, error_messages = @client.send(path, :get)
=======
        result, error_messages = @client.send_request(path, :get)

        logger.debug "##{__method__.to_s} => Completed"
>>>>>>> develop
        return result, error_messages
      end

    end
  end
end
