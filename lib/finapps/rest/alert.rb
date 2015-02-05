module FinApps
  module REST

    require 'erb'

    class Alert < FinApps::REST::Resources
      include FinApps::REST::Defaults

      # @return [Hash, Array<String>]
      def list(page = 1, requested=100, sort='date', asc=false, read='all')
        logger.debug "##{__method__.to_s} => Started"

        end_point = Defaults::END_POINTS[:alert_list]
        logger.debug "##{__method__.to_s} => end_point: #{end_point}"

        path = end_point.sub ':page', ERB::Util.url_encode(page)
        path = path.sub ':requested', ERB::Util.url_encode(requested)
        path = path.sub ':sort', ERB::Util.url_encode(sort)
        path = path.sub ':asc', ERB::Util.url_encode(asc)
        path = path.sub ':read', ERB::Util.url_encode(read)
        logger.debug "##{__method__.to_s} => path: #{path}"

        result, error_messages = @client.send(path, :get)

        logger.debug "##{__method__.to_s} => Completed"
        return result, error_messages
      end

      # @return [Hash, Array<String>]
      def update(alert_id, read=true)
        logger.debug "##{__method__.to_s} => Started"

        raise MissingArgumentsError.new 'Missing argument: alert_id.' if alert_id.blank?
        logger.debug "##{__method__.to_s} => alert_id: #{alert_id.inspect}"
        raise MissingArgumentsError.new 'Missing argument: alert_id.' if read.blank?
        logger.debug "##{__method__.to_s} => alert_id: #{read.inspect}"

        end_point = Defaults::END_POINTS[:alert_update]
        logger.debug "##{__method__.to_s} => end_point: #{end_point}"

        path = end_point.sub ':alert_id', ERB::Util.url_encode(alert_id)
        path = path.sub ':read', ERB::Util.url_encode(read)
        logger.debug "##{__method__.to_s} => path: #{path}"

        _, error_messages = @client.send(path, :put)

        logger.debug "##{__method__.to_s} => Completed"
        error_messages
      end

      # @return [Hash, Array<String>]
      def delete(alert_id)
        logger.debug "##{__method__.to_s} => Started"

        raise MissingArgumentsError.new 'Missing argument: alert_id.' if alert_id.blank?
        logger.debug "##{__method__.to_s} => alert_id: #{alert_id.inspect}"
        raise MissingArgumentsError.new 'Missing argument: alert_id.' if read.blank?
        logger.debug "##{__method__.to_s} => alert_id: #{read.inspect}"

        end_point = Defaults::END_POINTS[:alert_delete]
        logger.debug "##{__method__.to_s} => end_point: #{end_point}"

        path = end_point.sub ':alert_id', ERB::Util.url_encode(alert_id)
        path = path.sub ':read', ERB::Util.url_encode(read)
        logger.debug "##{__method__.to_s} => path: #{path}"

        _, error_messages = @client.send(path, :delete)

        logger.debug "##{__method__.to_s} => Completed"
        error_messages
      end

    end
  end
end