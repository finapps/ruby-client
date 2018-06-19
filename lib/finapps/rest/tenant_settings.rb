module FinApps
  module REST
    class TenantSettings < FinAppsCore::REST::Resources
      END_POINT = 'settings/app'

      def show
        super nil, END_POINT
      end

      def update(params)
        super params, END_POINT
      end
    end
  end
end