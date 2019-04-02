# frozen_string_literal: true

module FinApps
  module REST
    class ConsumerInstitutionRefresh < FinAppsCore::REST::Resources
      def update(id, params = {})
        not_blank(id, :id)

        path = "institutions/consumer/#{ERB::Util.url_encode(id)}/refresh"
        super params, path
      end
    end
  end
end
