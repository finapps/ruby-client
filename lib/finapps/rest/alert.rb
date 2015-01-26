module FinApps
  module REST

    require 'erb'

    class Alert < FinApps::REST::Resources
      include FinApps::REST::Defaults

      # @return [Hash, Array<String>]
      def list(page = 1, requested=100, sort='date', asc=false, read=false)
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
      def update(params)
        logger.debug "##{__method__.to_s} => Started"

        raise MissingArgumentsError.new 'Missing argument: params.' if params.blank?
        logger.debug "##{__method__.to_s} => params: #{params.inspect}"

        end_point = Defaults::END_POINTS[:alert_update]
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