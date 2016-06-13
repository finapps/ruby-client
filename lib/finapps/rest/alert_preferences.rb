module FinApps
  module REST

    require 'erb'

    class AlertPreferences < FinApps::REST::Resources
      include FinApps::REST::Defaults

      # @return [Hash, Array<String>]
      def show
        end_point = Defaults::END_POINTS[:alert_preferences_show]
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
      def update(params)
        raise MissingArgumentsError.new 'Missing argument: params.' if params.blank?
        logger.debug "##{__method__.to_s} => params: #{params.inspect}"

        end_point = Defaults::END_POINTS[:alert_preferences_update]
        logger.debug "##{__method__.to_s} => end_point: #{end_point}"

        path = end_point
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
