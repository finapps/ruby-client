# frozen_string_literal: true

module FinApps
  module REST
    class Statements < FinAppsCore::REST::Resources
      def show(account_id, document_id)
        not_blank(account_id, :account_id)
        not_blank(document_id, :document_id)

        path = "accounts/#{ERB::Util.url_encode(account_id)}/statement/#{ERB::Util.url_encode(document_id)}"
        super nil, path
      end
    end
  end
end
