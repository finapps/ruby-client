module FinApps
  module REST

    require 'erb'

    class AlertSettings < FinApps::REST::Resources
      include FinApps::REST::Defaults

      # Shows alert settings for a given user.
      # @return [Hash, Array<String>]
      def show
        end_point = Defaults::END_POINTS[:alert_settings_show]
        logger.debug "##{__method__} => end_point: #{end_point}"

        path = end_point
        logger.debug "##{__method__} => path: #{path}"

        result, error_messages = client.send_request(path, :get)
        return result, error_messages
      end

      # Updates alert settings for a given user.
      # @return [Hash, Array<String>]
      def update(params)
        raise MissingArgumentsError.new 'Missing argument: params.' if params.blank?
        logger.debug "##{__method__} => params: #{params.inspect}"

        end_point = Defaults::END_POINTS[:alert_settings_update]
        logger.debug "##{__method__} => end_point: #{end_point}"

        path = end_point
        logger.debug "##{__method__} => path: #{path}"

        _, error_messages = client.send_request(path, :put, params.compact)
        error_messages
      end

    end
  end
end