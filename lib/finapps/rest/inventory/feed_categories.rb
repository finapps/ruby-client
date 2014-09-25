module FinApps
  module REST
    module Inventory

      require 'erb'

      class FeedCategories < FinApps::REST::Resources

        def list(feed_name, region = nil, city = nil)
          logger.debug "##{__method__.to_s} => Started"

          raise MissingArgumentsError.new 'Missing argument: feed_name.' if feed_name.blank?
          logger.debug "##{__method__.to_s} => feed_name: #{feed_name}"

          raise MissingArgumentsError.new 'Missing argument: region.' if region.blank? && city.present?
          logger.debug "##{__method__.to_s} => region: #{region}"

          raise MissingArgumentsError.new 'Missing argument: city.' if region.present? && city.blank?
          logger.debug "##{__method__.to_s} => city: #{city}"

          if region.present? && city.present?
            end_point = Defaults::END_POINTS[:inventory_feed_categories_list_by_region]
            path = end_point.sub ':feed_name', ERB::Util.url_encode(feed_name)
            path = path.sub ':region', ERB::Util.url_encode(region)
            path = path.sub ':city', ERB::Util.url_encode(city)
          else
            end_point = Defaults::END_POINTS[:inventory_feed_categories_list]
            path = end_point.sub ':feed_name', ERB::Util.url_encode(feed_name)
          end
          logger.debug "##{__method__.to_s} => end_point: #{end_point}"
          logger.debug "##{__method__.to_s} => path: #{path}"

          results, error_messages = @client.send(path, :get)

          logger.debug "##{__method__.to_s} => Completed"
          return results, error_messages
        end

      end

    end
  end
end