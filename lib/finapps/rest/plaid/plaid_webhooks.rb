# frozen_string_literal: true

module FinApps
  module REST
    class PlaidWebhooks < FinAppsCore::REST::Resources # :nodoc:
      def create
        super({}, '/p/webhook')
      end
    end
  end
end
