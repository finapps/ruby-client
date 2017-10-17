# frozen_string_literal: true

module FinApps
  module REST
    class PasswordResets < FinAppsCore::REST::Resources # :nodoc:
      def create(id)
        not_blank(id, :id)

        path = "tenant/#{ERB::Util.url_encode(id)}/password"
        super nil, path
      end

      def update(id, params)
        not_blank(id, :id)
        not_blank(params, :params)

        path = "tenant/#{ERB::Util.url_encode(id)}/password"
        super params, path
      end
    end
  end
end
