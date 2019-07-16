# frozen_string_literal: true

module SpecHelpers
  module Client
    def client(tenant_token = :tenant_token)
      FinApps::REST::Client.new tenant_token, rashify: true
    end
  end
end
