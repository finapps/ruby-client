# frozen_string_literal: true
module FinApps
  module REST
    class UserInstitutions < FinAppsCore::REST::Resources # :nodoc:
      using ObjectExtensions
      using StringExtensions

      def list
        super END_POINT
      end

      def create(site_id, params)
        not_blank(site_id, :site_id)
        not_blank(params, :params)

        path = "institutions/site/#{ERB::Util.url_encode(site_id)}/add"

        super params, path
      end

      def show(id)
        not_blank(id, :id)
        super(id, user_institutions_path(id))
      end

      def credentials_update(id, params)
        update id, params, 'credentials'
      end

      def mfa_update(id, params)
        update id, params, 'mfa'
      end

      def destroy(id)
        not_blank(id, :id)
        super(id, user_institutions_path(id))
      end

      private

      END_POINT = 'institutions/user'

      def update(id, params, method)
        not_blank(id, :id)
        not_blank(params, :params)

        path = "#{user_institutions_path(id)}/#{method}"
        super params, path
      end

      def user_institutions_path(id)
        "#{END_POINT}/#{ERB::Util.url_encode(id)}"
      end
    end
  end
end
