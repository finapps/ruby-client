# frozen_string_literal: true
module FinApps
  module REST
    class OrderTokens < FinAppsCore::REST::Resources # :nodoc:
      include ::FinAppsCore::Utils::Validatable
      using ObjectExtensions
      using StringExtensions

      def show(token)
        not_blank(token, :token)
        create nil, "orders/#{ERB::Util.url_encode(token)}"
      end
    end
  end
end
