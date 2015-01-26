module FinApps
  module REST

    require 'erb'

    class AlertSetting < FinApps::REST::Resources
      include FinApps::REST::Defaults

      # @return [Hash, Array<String>]
      def list
        logger.debug "##{__method__.to_s} => Started"

        end_point = Defaults::END_POINTS[:alert_setting_list]
        logger.debug "##{__method__.to_s} => end_point: #{end_point}"

        path = end_point
        logger.debug "##{__method__.to_s} => path: #{path}"

        result, error_messages = @client.send(path, :get)

        logger.debug "##{__method__.to_s} => Completed"
        return result, error_messages
      end

      # @return [Hash, Array<String>]
      def update(params)
        logger.debug "##{__method__.to_s} => Started"

        raise MissingArgumentsError.new 'Missing argument: params.' if params.blank?
        logger.debug "##{__method__.to_s} => params: #{params.inspect}"

        end_point = Defaults::END_POINTS[:alert_setting_update]
        logger.debug "##{__method__.to_s} => end_point: #{end_point}"

        path = end_point
        logger.debug "##{__method__.to_s} => path: #{path}"

        _, error_messages = @client.send(path, :put, params.compact)

        logger.debug "##{__method__.to_s} => Completed"
        error_messages
      end

    end
  end
end