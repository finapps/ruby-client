# frozen_string_literal: true

module FinApps
  module REST
    class OperatorLoginTokens < FinAppsCore::REST::Resources
      def create(params)
        not_blank(params, :params)
        super params, 'login/operators/token'
      end
    end
  end
end
