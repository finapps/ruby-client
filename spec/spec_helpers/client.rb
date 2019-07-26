# frozen_string_literal: true

module SpecHelpers
  module Client
    def client(tenant_token = :tenant_token)
      logger = Logger.new(IO::NULL)
      FinApps::REST::Client.new tenant_token, { rashify: true }, logger
    end
  end
end
