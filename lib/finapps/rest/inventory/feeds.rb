module FinApps
  module REST
    module Inventory

      require 'erb'

      class Feeds < FinApps::REST::Resources

        def list
          logger.debug "##{__method__.to_s} => Started"

          end_point = Defaults::END_POINTS[:inventory_feeds_list]
          logger.debug "##{__method__.to_s} => end_point: #{end_point}"

          path = end_point
          logger.debug "##{__method__.to_s} => path: #{path}"

          results, error_messages = @client.send(path, :get)

          logger.debug "##{__method__.to_s} => Completed"
          return results, error_messages
        end

        def show(feed_name)
          logger.debug "##{__method__.to_s} => Started"

          raise MissingArgumentsError.new 'Missing argument: feed_name.' if feed_name.blank?
          logger.debug "##{__method__.to_s} => feed_name: #{feed_name}"

          end_point = Defaults::END_POINTS[:inventory_feed_show]
          logger.debug "##{__method__.to_s} => end_point: #{end_point}"

          path = end_point.sub ':feed_name', ERB::Util.url_encode(feed_name)
          logger.debug "##{__method__.to_s} => path: #{path}"

          results, error_messages = @client.send(path, :get)

          logger.debug "##{__method__.to_s} => Completed"
          return results, error_messages
        end

      end

    end
  end
end