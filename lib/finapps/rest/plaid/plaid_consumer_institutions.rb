# frozen_string_literal: true

module FinApps
  module REST
    class PlaidConsumerInstitutions < PlaidResources # :nodoc:
      def create(params)
        super(params, 'p/institution/consumer')
      end

      def show(id, options = { show_accounts: false })
        results, error_messages = super(nil, "p/institution/consumer/#{id}")

        if error_messages.empty? && options[:show_accounts]
          account_results, error_messages = super(nil, "p/institution/consumer/#{id}/account")
          results[:accounts] = account_results if error_messages.empty?
        end

        [results, error_messages]
      end

      def list
        super 'p/institution/consumer'
      end
    end
  end
end
