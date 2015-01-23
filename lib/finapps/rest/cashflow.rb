module FinApps
  module REST

    require 'erb'

    class Cashflow < FinApps::REST::Resources
      include FinApps::REST::Defaults

      # @param [Date] start_date
      # @param [Date] end_date
      # @return [Hash, Array<String>]
      def show(start_date, end_date)
        logger.debug "##{__method__.to_s} => Started"

        raise MissingArgumentsError.new 'Missing argument: start_date.' if start_date.blank?
        logger.debug "##{__method__.to_s} => start_date: #{start_date}"
        raise MissingArgumentsError.new 'Missing argument: end_date.' if end_date.blank?
        logger.debug "##{__method__.to_s} => end_date: #{end_date}"

        end_point = Defaults::END_POINTS[:cashflow_show]
        logger.debug "##{__method__.to_s} => end_point: #{end_point}"

        path = end_point.sub(':start_date', ERB::Util.url_encode(start_date)).sub(':end_date', ERB::Util.url_encode(end_date))
        logger.debug "##{__method__.to_s} => path: #{path}"

        budget, error_messages = @client.send(path, :get)

        logger.debug "##{__method__.to_s} => Completed"
        return budget, error_messages
      end

    end
  end
end