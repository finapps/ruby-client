# frozen_string_literal: true

module FinApps
  module REST
    class ConsumerInstitutionRefreshes < FinAppsCore::REST::Resources
      def create
        path = 'institutions/refresh'
        update nil, path
      end
    end
  end
end
