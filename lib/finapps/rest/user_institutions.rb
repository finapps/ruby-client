# frozen_string_literal: true
module FinApps
  module REST
    class UserInstitutions < FinAppsCore::REST::Resources # :nodoc:
      include ::FinAppsCore::Utils::Validatable

      END_POINT = 'institutions/user'

      using ObjectExtensions
      using StringExtensions

      def list
        path = 'institutions/user'
        super path
      end

      def create(site_id, params)
        not_blank(site_id, :site_id)
        not_blank(params, :params)

        path = "institutions/site/#{ERB::Util.url_encode(site_id)}/add"

        super params, path
      end

      def show(id)
        not_blank(id, :id)

        path = "#{END_POINT}/#{ERB::Util.url_encode(id)}"
        super id, path
      end

      def credentials_update(id, params)
        not_blank(id, :id)
        not_blank(params, :params)

        path = "#{END_POINT}/#{ERB::Util.url_encode(id)}/credentials"
        update params, path
      end

      def mfa_update(id, params)
        not_blank(id, :id)
        not_blank(params, :params)

        path = "#{END_POINT}/#{ERB::Util.url_encode(id)}/mfa"
        update params, path
      end

      def destroy(id)
        not_blank(id, :id)

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
