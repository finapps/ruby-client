# frozen_string_literal: true

module FinApps
  module REST
    class TenantAppSettings < FinAppsCore::REST::Resources
      END_POINT = 'settings/app'

      def show
        super nil, END_POINT
      end

      def update(params)
        not_blank params, :params
        super params, END_POINT
      end
    end
  end
end
