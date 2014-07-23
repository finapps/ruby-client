module FinApps
  module REST

    require 'erb'

    class UserInstitutions < FinApps::REST::Resources
      include FinApps::REST::Defaults

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

        user_institution, error_messages = @client.post(path, :parameters => parameters ) { |r| UserInstitution.new(r.body) }

        logger.debug "##{__method__.to_s} => Completed"
        return user_institution, error_messages
      end

    end

    class UserInstitution < FinApps::REST::Resource
      attr_accessor :_id, :account_id, :user_public_id, :institution_name, :status, :status_message
    end

  end
end