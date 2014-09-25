module FinApps
  module REST

    require 'erb'

    class Geo < FinApps::REST::Resources

      def record_by_ip_address(ip_address)
        logger.debug "##{__method__.to_s} => Started"

        raise MissingArgumentsError.new 'Missing argument: ip_address.' if ip_address.blank?
        logger.debug "##{__method__.to_s} => ip_address: #{ip_address}"

        end_point = Defaults::END_POINTS[:geo_record_by_ip_address]
        logger.debug "##{__method__.to_s} => end_point: #{end_point}"

        path = end_point.sub ':ip_address', ERB::Util.url_encode(ip_address)
        logger.debug "##{__method__.to_s} => path: #{path}"

        results, error_messages = @client.send(path, :get)

        logger.debug "##{__method__.to_s} => Completed"
        return results, error_messages
      end

      def record_by_region(region, city)
        logger.debug "##{__method__.to_s} => Started"

        raise MissingArgumentsError.new 'Missing argument: region.' if region.blank?
        logger.debug "##{__method__.to_s} => region: #{region}"
        raise MissingArgumentsError.new 'Missing argument: city.' if city.blank?
        logger.debug "##{__method__.to_s} => city: #{city}"

        end_point = Defaults::END_POINTS[:geo_record_by_region]
        logger.debug "##{__method__.to_s} => end_point: #{end_point}"

        path = end_point.sub ':region', ERB::Util.url_encode(region)
        path = path.sub ':city', ERB::Util.url_encode(city)
        logger.debug "##{__method__.to_s} => path: #{path}"

        results, error_messages = @client.send(path, :get)

        logger.debug "##{__method__.to_s} => Completed"
        return results, error_messages
      end

      def postal_record_by_region(region, city)
        logger.debug "##{__method__.to_s} => Started"

        raise MissingArgumentsError.new 'Missing argument: region.' if region.blank?
        logger.debug "##{__method__.to_s} => region: #{region}"
        raise MissingArgumentsError.new 'Missing argument: city.' if city.blank?
        logger.debug "##{__method__.to_s} => city: #{city}"

        end_point = Defaults::END_POINTS[:geo_postal_record_by_region]
        logger.debug "##{__method__.to_s} => end_point: #{end_point}"

        path = end_point.sub ':region', ERB::Util.url_encode(region)
        path = path.sub ':city', ERB::Util.url_encode(city)
        logger.debug "##{__method__.to_s} => path: #{path}"

        results, error_messages = @client.send(path, :get)

        logger.debug "##{__method__.to_s} => Completed"
        return results, error_messages
      end

      def postal_record_by_postal_code(postal)
        logger.debug "##{__method__.to_s} => Started"

        raise MissingArgumentsError.new 'Missing argument: postal.' if postal.blank?
        logger.debug "##{__method__.to_s} => postal: #{postal}"

        end_point = Defaults::END_POINTS[:geo_postal_record_by_postal_code]
        logger.debug "##{__method__.to_s} => end_point: #{end_point}"

        path = end_point.sub ':postal', ERB::Util.url_encode(postal)
        logger.debug "##{__method__.to_s} => path: #{path}"

        results, error_messages = @client.send(path, :get)

        logger.debug "##{__method__.to_s} => Completed"
        return results, error_messages
      end

      def us_record_by_region(region, city)
        logger.debug "##{__method__.to_s} => Started"

        raise MissingArgumentsError.new 'Missing argument: region.' if region.blank?
        logger.debug "##{__method__.to_s} => region: #{region}"
        raise MissingArgumentsError.new 'Missing argument: city.' if city.blank?
        logger.debug "##{__method__.to_s} => city: #{city}"

        end_point = Defaults::END_POINTS[:geo_us_record_by_region]
        logger.debug "##{__method__.to_s} => end_point: #{end_point}"

        path = end_point.sub ':region', ERB::Util.url_encode(region)
        path = path.sub ':city', ERB::Util.url_encode(city)
        logger.debug "##{__method__.to_s} => path: #{path}"

        results, error_messages = @client.send(path, :get)

        logger.debug "##{__method__.to_s} => Completed"
        return results, error_messages
      end

    end

  end
end