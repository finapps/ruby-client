module FinApps
  module REST

    require 'erb'

    class Relevance < FinApps::REST::Resources

      def rulesets
        logger.debug "##{__method__.to_s} => Started"

        end_point = Defaults::END_POINTS[:relevance_rulesets]
        logger.debug "##{__method__.to_s} => end_point: #{end_point}"

        path = end_point
        logger.debug "##{__method__.to_s} => path: #{path}"

        results, error_messages = @client.send(path, :get)

        logger.debug "##{__method__.to_s} => Completed"
        return results, error_messages
      end

      def ruleset_by_name(ruleset_name)
        logger.debug "##{__method__.to_s} => Started"

        raise MissingArgumentsError.new 'Missing argument: ruleset_name.' if ruleset_name.blank?
        logger.debug "##{__method__.to_s} => ruleset_name: #{ruleset_name}"

        end_point = Defaults::END_POINTS[:relevance_ruleset_by_name]
        logger.debug "##{__method__.to_s} => end_point: #{end_point}"

        path = end_point.sub ':ruleset_name', ERB::Util.url_encode(ruleset_name)
        logger.debug "##{__method__.to_s} => path: #{path}"

        results, error_messages = @client.send(path, :get)

        logger.debug "##{__method__.to_s} => Completed"
        return results, error_messages
      end

      def update_ruleset(params = {})
        logger.debug "##{__method__.to_s} => Started"

        raise MissingArgumentsError.new 'Missing argument: params.' if params.blank?
        logger.debug "##{__method__.to_s} => params: #{params.inspect}"

        end_point = Defaults::END_POINTS[:relevance_update_ruleset]
        logger.debug "##{__method__.to_s} => end_point: #{end_point}"

        path = end_point
        logger.debug "##{__method__.to_s} => path: #{path}"

        results, error_messages = @client.send(path, :post, params)

        logger.debug "##{__method__.to_s} => Completed"
        return results, error_messages
      end

      def run_ruleset_by_name(params = {})
        logger.debug "##{__method__.to_s} => Started"

        raise MissingArgumentsError.new 'Missing argument: params.' if params.blank?
        logger.debug "##{__method__.to_s} => params: #{params.inspect}"

        end_point = Defaults::END_POINTS[:relevance_run_ruleset_by_name]
        logger.debug "##{__method__.to_s} => end_point: #{end_point}"

        path = end_point
        logger.debug "##{__method__.to_s} => path: #{path}"

        results, error_messages = @client.send(path, :post, params)

        logger.debug "##{__method__.to_s} => Completed"
        return results, error_messages
      end

      def run_ruleset_custom(params = {})
        logger.debug "##{__method__.to_s} => Started"

        raise MissingArgumentsError.new 'Missing argument: params.' if params.blank?
        logger.debug "##{__method__.to_s} => params: #{params.inspect}"

        end_point = Defaults::END_POINTS[:relevance_run_ruleset_custom]
        logger.debug "##{__method__.to_s} => end_point: #{end_point}"

        path = end_point
        logger.debug "##{__method__.to_s} => path: #{path}"

        results, error_messages = @client.send(path, :post, params)

        logger.debug "##{__method__.to_s} => Completed"
        return results, error_messages
      end

    end

  end
end