# frozen_string_literal: true

module FinApps
  module REST
    class ConsumerLoginTokens < FinAppsCore::REST::Resources
      def create(params)
        not_blank(params, :params)
        super params, 'login/token'
      end
    end
  end
end
