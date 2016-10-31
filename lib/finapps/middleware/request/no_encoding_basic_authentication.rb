module FinApps
  module Middleware
    class NoEncodingBasicAuthentication < Faraday::Request::BasicAuthentication
      def self.header(value)
        value.gsub!("\n", '')
        super(:Basic, value)
      end
    end
  end
end