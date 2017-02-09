# frozen_string_literal: true
module FinApps
  module REST
    class UserInstitutions < FinAppsCore::REST::Resources # :nodoc:
      END_POINT = 'institutions/user'

      using ObjectExtensions
      using StringExtensions

      def list
        path = 'institutions/user'
        super path
      end

      def create(site_id, params)
        raise FinAppsCore::MissingArgumentsError.new 'Missing argument: site_id.' if site_id.blank?
        raise FinAppsCore::MissingArgumentsError.new 'Missing argument: params.' if params.blank?

        path = "institutions/site/#{ERB::Util.url_encode(site_id)}/add"

        super params, path
      end

      def show(id)
        raise FinAppsCore::MissingArgumentsError.new 'Missing Argument: id.' if id.blank?

        path = "#{END_POINT}/#{ERB::Util.url_encode(id)}"
        super id, path
      end

      def credentials_update(id, params)
        raise FinAppsCore::MissingArgumentsError.new 'Missing Argument: id.' if id.blank?
        raise FinAppsCore::MissingArgumentsError.new 'Missing argument: params.' if params.blank?

        path = "#{END_POINT}/#{ERB::Util.url_encode(id)}/credentials"
        update params, path
      end

      def mfa_update(id, params)
        raise FinAppsCore::MissingArgumentsError.new 'Missing Argument: id.' if id.blank?
        raise FinAppsCore::MissingArgumentsError.new 'Missing argument: params.' if params.blank?

        path = "#{END_POINT}/#{ERB::Util.url_encode(id)}/mfa"
        update params, path
      end

      def destroy(id)
        raise FinAppsCore::MissingArgumentsError.new 'Missing Argument: id.' if id.blank?

        path = "#{END_POINT}/#{ERB::Util.url_encode(id)}"
        super id, path
      end

      private

      def update(params, path)
        super params, path
      end
    end
  end
end
