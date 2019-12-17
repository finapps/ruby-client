# frozen_string_literal: true

require 'erb'

module FinApps
  module REST
    class PlaidConsumerInstitutions < PlaidResources # :nodoc:
      def create(params)
        super(params, 'p/institution/consumer')
      end

      def show(id, options = { show_accounts: false })
        results, error_messages = super(nil, "p/institution/consumer/#{id}")

        if error_messages.empty? && options[:show_accounts]
          account_results, error_messages =
            super(nil, "p/institution/consumer/#{id}/account")
          results[:accounts] = account_results if error_messages.empty?
        end

        [results, error_messages]
      end

      def list
        super 'p/institution/consumer'
      end

      def destroy(id)
        not_blank(id, :consumer_institution_id)

        super id, "p/institution/consumer/#{id}"
      end
    end
  end
end
