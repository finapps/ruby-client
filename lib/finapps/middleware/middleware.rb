# frozen_string_literal: true
require 'faraday' unless defined? Faraday

module FinApps
  module Middleware
    autoload :AcceptJson, 'finapps/middleware/request/accept_json'
    autoload :UserAgent, 'finapps/middleware/request/user_agent'
    autoload :TenantAuthentication, 'finapps/middleware/request/tenant_authentication'

    if Faraday::Middleware.respond_to? :register_middleware
      Faraday::Request.register_middleware \
        accept_json: -> { AcceptJson },
        user_agent: -> { UserAgent },
        tenant_authentication: -> { TenantAuthentication }
    end
  end
end
