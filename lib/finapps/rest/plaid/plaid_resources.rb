# frozen_string_literal: true

module FinApps
  module REST
    class PlaidResources < FinAppsCore::REST::Resources # :nodoc:
      protected

      def end_point
        super.gsub('plaid', 'p/')
      end
    end
  end
end
