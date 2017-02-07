# frozen_string_literal: true
module FinApps
  module REST
    class UserInstitutionsForms < FinAppsCore::REST::Resources
      using ObjectExtensions
      using StringExtensions

      def show(id)
        raise MissingArgumentsError.new 'Missing argument: id.' if id.blank?

        path = "institutions/user/#{ERB::Util.url_encode(id)}/form"
        super id, path
      end
    end
  end
end
