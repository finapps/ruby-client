# frozen_string_literal: true

module FinApps
  module REST
    class InstitutionsForms < FinAppsCore::REST::Resources
      def show(site_id)
        not_blank(site_id, :site_id)

        path = "institutions/site/#{ERB::Util.url_encode(site_id)}/form"
        super site_id, path
      end
    end
  end
end
