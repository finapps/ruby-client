# frozen_string_literal: true
module FinApps
  module REST
    class UserInstitutionsStatuses < FinAppsCore::REST::Resources # :nodoc:
      def show(id)
        not_blank(id, :id)

        path = "institutions/consumer/#{ERB::Util.url_encode(id)}/status"
        super id, path
      end

      def update
        path = 'institutions/refresh'
        super nil, path
      end
    end
  end
end
