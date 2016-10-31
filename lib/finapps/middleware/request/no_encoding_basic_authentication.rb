# frozen_string_literal: true
module FinApps
  module Middleware
    class NoEncodingBasicAuthentication < ::Faraday::Request.load_middleware(:authorization)
      def self.header(value)
        sanitized = value.delete("\n")
        super(:Basic, sanitized)
      end
    end
  end
end
