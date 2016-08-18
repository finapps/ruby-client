# frozen_string_literal: true
module FinApps
  module REST
    class UserInstitutionsStatuses < FinApps::REST::Resources # :nodoc:
      using ObjectExtensions
      using StringExtensions

      def show(id)
        raise MissingArgumentsError.new 'Missing argument: ui_id' if id.blank?

        path = "institutions/user/#{ERB::Util.url_encode(id)}/status"
        super id, path
      end

      def update
        path = 'institutions/refresh'
        super nil, path
      end
    end
  end
end
