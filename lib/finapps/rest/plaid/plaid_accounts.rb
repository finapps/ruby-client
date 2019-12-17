# frozen_string_literal: true

module FinApps
  module REST
    class PlaidAccounts < PlaidResources # :nodoc:
      def show(id)
        super(nil, "p/account/#{id}")
      end

      def list
        super 'p/account'
      end
    end
  end
end
