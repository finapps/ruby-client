module FinApps
  module REST

    require 'erb'

    class UserInstitutions < FinApps::REST::Resources
      include FinApps::REST::Defaults

      def list
        logger.debug "##{__method__.to_s} => Started"

        path = Defaults::END_POINTS[:user_institutions_list]
        logger.debug "##{__method__.to_s} => path: #{path}"

        user_institutions, error_messages = @client.send(path, :get)

        logger.debug "##{__method__.to_s} => Completed"
        return user_institutions, error_messages
      end

      def add(site_id, parameters)
        logger.debug "##{__method__.to_s} => Started"

        raise MissingArgumentsError.new 'Missing argument: site_id.' if site_id.blank?
        logger.debug "##{__method__.to_s} => site_id: #{site_id}"

        raise MissingArgumentsError.new 'Missing argument: parameters.' if parameters.blank?
        logger.debug "##{__method__.to_s} => parameters: #{parameters.inspect}"

        end_point = Defaults::END_POINTS[:user_institutions_add]
        logger.debug "##{__method__.to_s} => end_point: #{end_point}"

        path = end_point.sub ':site_id', ERB::Util.url_encode(site_id)
        logger.debug "##{__method__.to_s} => path: #{path}"

        user_institution, error_messages = @client.send(path, :post, :parameters => parameters)

        logger.debug "##{__method__.to_s} => Completed"
        return user_institution, error_messages
      end

      def show(user_institution_id)
        logger.debug "##{__method__.to_s} => Started"

        raise MissingArgumentsError.new 'Missing argument: user_institution_id.' if user_institution_id.blank?
        logger.debug "##{__method__.to_s} => user_institution_id: #{user_institution_id}"

        end_point = Defaults::END_POINTS[:user_institutions_show]
        logger.debug "##{__method__.to_s} => end_point: #{end_point}"

        path = end_point.sub ':user_institution_id', ERB::Util.url_encode(user_institution_id)
        logger.debug "##{__method__.to_s} => path: #{path}"

        user_institution, error_messages = @client.send(path, :get)

        logger.debug "##{__method__.to_s} => Completed"
        return user_institution, error_messages
      end

      def form(user_institution_id)
        logger.debug "##{__method__.to_s} => Started"

        raise MissingArgumentsError.new 'Missing argument: user_institution_id.' if user_institution_id.blank?
        logger.debug "##{__method__.to_s} => user_institution_id: #{user_institution_id}"

        end_point = Defaults::END_POINTS[:user_institutions_form]
        logger.debug "##{__method__.to_s} => end_point: #{end_point}"

        path = end_point.sub ':user_institution_id', ERB::Util.url_encode(user_institution_id)
        logger.debug "##{__method__.to_s} => path: #{path}"

        user_institution, error_messages = @client.send(path, :get)

        logger.debug "##{__method__.to_s} => Completed"
        return user_institution, error_messages
      end

      def status(user_institution_id)
        logger.debug "##{__method__.to_s} => Started"

        raise MissingArgumentsError.new 'Missing argument: user_institution_id.' if user_institution_id.blank?
        logger.debug "##{__method__.to_s} => user_institution_id: #{user_institution_id}"

        end_point = Defaults::END_POINTS[:user_institutions_status]
        logger.debug "##{__method__.to_s} => end_point: #{end_point}"

        path = end_point.sub ':user_institution_id', ERB::Util.url_encode(user_institution_id)
        logger.debug "##{__method__.to_s} => path: #{path}"

        user_institution, error_messages = @client.send(path, :get)

        logger.debug "##{__method__.to_s} => Completed"
        return user_institution, error_messages
      end

      def mfa(user_institution_id, parameters)
        logger.debug "##{__method__.to_s} => Started"

        raise MissingArgumentsError.new 'Missing argument: user_institution_id.' if user_institution_id.blank?
        logger.debug "##{__method__.to_s} => user_institution_id: #{user_institution_id}"

        raise MissingArgumentsError.new 'Missing argument: parameters.' if parameters.blank?
        logger.debug "##{__method__.to_s} => parameters: #{parameters.inspect}"

        end_point = Defaults::END_POINTS[:user_institutions_mfa]
        logger.debug "##{__method__.to_s} => end_point: #{end_point}"

        path = end_point.sub ':user_institution_id', ERB::Util.url_encode(user_institution_id)
        logger.debug "##{__method__.to_s} => path: #{path}"

        user_institution, error_messages = @client.send(path, :put, :parameters => parameters)

        logger.debug "##{__method__.to_s} => Completed"
        return user_institution, error_messages
      end

      def update(user_institution_id, parameters)
        logger.debug "##{__method__.to_s} => Started"

        raise MissingArgumentsError.new 'Missing argument: user_institution_id.' if user_institution_id.blank?
        logger.debug "##{__method__.to_s} => user_institution_id: #{user_institution_id}"

        raise MissingArgumentsError.new 'Missing argument: parameters.' if parameters.blank?
        logger.debug "##{__method__.to_s} => parameters: #{parameters.inspect}"

        end_point = Defaults::END_POINTS[:user_institutions_update]
        logger.debug "##{__method__.to_s} => end_point: #{end_point}"

        path = end_point.sub ':user_institution_id', ERB::Util.url_encode(user_institution_id)
        logger.debug "##{__method__.to_s} => path: #{path}"

        user_institution, error_messages = @client.send(path, :put, :parameters => parameters)

        logger.debug "##{__method__.to_s} => Completed"
        return user_institution, error_messages
      end

      def refresh
        logger.debug "##{__method__.to_s} => Started"

        path = Defaults::END_POINTS[:user_institutions_refresh]
        logger.debug "##{__method__.to_s} => path: #{path}"

        user_institutions, error_messages = @client.send(path, :get)

        logger.debug "##{__method__.to_s} => Completed"
        return user_institutions, error_messages
      end

      # @return [Hash, Array<String>]
      def delete(user_institution_id)
        logger.debug "##{__method__.to_s} => Started"

        raise MissingArgumentsError.new 'Missing argument: user_institution_id.' if user_institution_id.blank?
        logger.debug "##{__method__.to_s} => user_institution_id: #{user_institution_id.inspect}"

        end_point = Defaults::END_POINTS[:user_institutions_delete]
        logger.debug "##{__method__.to_s} => end_point: #{end_point}"

        path = end_point.sub ':user_institution_id', ERB::Util.url_encode(user_institution_id)
        logger.debug "##{__method__.to_s} => path: #{path}"

        _, error_messages = @client.send(path, :delete)

        logger.debug "##{__method__.to_s} => Completed"
        error_messages
      end

    end

  end
end