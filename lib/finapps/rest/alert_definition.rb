module FinApps
  module REST

    require 'erb'

    class AlertDefinition < FinApps::REST::Resources
      include FinApps::REST::Defaults

      # Returns a list of alert definitions for current tenant.
      # @return [Hash, Array<String>]
      def list
        end_point = Defaults::END_POINTS[:alert_definition_list]
        logger.debug "##{__method__} => end_point: #{end_point}"

        path = end_point
        logger.debug "##{__method__} => path: #{path}"

        result, error_messages = client.send_request(path, :get)
        return result, error_messages
      end

      # Shows a single alert definition matching the given alert name.
      # @return [Hash, Array<String>]
      def show(alert_name)
        raise MissingArgumentsError.new 'Missing argument: alert_name.' if alert_name.blank?
        logger.debug "##{__method__} => alert_name: #{alert_name}"

        end_point = Defaults::END_POINTS[:alert_definition_show]
        logger.debug "##{__method__} => end_point: #{end_point}"

        path = end_point.sub ':alert_name', ERB::Util.url_encode(alert_name)
        logger.debug "##{__method__} => path: #{path}"

        result, error_messages = client.send_request(path, :get)
        return result, error_messages
      end

    end
  end
end