# frozen_string_literal: true
module SpecHelpers
  module Client
    def client
      FinApps::REST::Client.new :tenant_token
    end
  end
end
