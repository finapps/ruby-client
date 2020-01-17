# frozen_string_literal: true

module FinApps
  module REST
    class PlaidWebhooks < PlaidResources # :nodoc:
      def show
        send_request_for_id 'p/metadata', :get, nil
      end
    end
  end
end
