module FinApps
  module REST
    module Relevance

      require 'erb'

      class Rulesets < FinApps::REST::Resources

        def list


          end_point = Defaults::END_POINTS[:relevance_rulesets_list]
          logger.debug "##{__method__} => end_point: #{end_point}"

          path = end_point
          logger.debug "##{__method__} => path: #{path}"

          results, error_messages = @client.send_request(path, :get)


          return results, error_messages
        end

        def show(ruleset_name)


          raise MissingArgumentsError.new 'Missing argument: ruleset_name.' if ruleset_name.blank?
          logger.debug "##{__method__} => ruleset_name: #{ruleset_name}"

          end_point = Defaults::END_POINTS[:relevance_rulesets_show]
          logger.debug "##{__method__} => end_point: #{end_point}"

          path = end_point.sub ':ruleset_name', ERB::Util.url_encode(ruleset_name)
          logger.debug "##{__method__} => path: #{path}"

          results, error_messages = @client.send_request(path, :get)


          return results, error_messages
        end

        def run(params = {})


          raise MissingArgumentsError.new 'Missing argument: params.' if params.blank?
          logger.debug "##{__method__} => params: #{params.inspect}"

          end_point = Defaults::END_POINTS[:relevance_rulesets_run]
          logger.debug "##{__method__} => end_point: #{end_point}"

          path = end_point
          logger.debug "##{__method__} => path: #{path}"

          results, error_messages = @client.send_request(path, :post, params)


          return results, error_messages
        end

      end
    end

  end
end
