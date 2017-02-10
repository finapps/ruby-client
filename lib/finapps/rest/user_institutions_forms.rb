# frozen_string_literal: true
module FinApps
  module REST
    class UserInstitutionsForms < FinAppsCore::REST::Resources
      include ::FinAppsCore::Utils::Validatable
      using ObjectExtensions
      using StringExtensions

      def show(id)
        not_blank(id, :id)

        path = "institutions/user/#{ERB::Util.url_encode(id)}/form"
        super id, path
      end
    end
  end
end
