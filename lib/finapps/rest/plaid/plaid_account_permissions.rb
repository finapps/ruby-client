# frozen_string_literal: true

module FinApps
  module REST
    class PlaidAccountPermissions < PlaidResources # :nodoc:
      def create(id)
        send_request 'p/accounts/permissions', :put, ids: [id]
      end

      def destroy(id)
        send_request 'p/accounts/permissions', :delete, ids: [id]
      end
    end
  end
end
