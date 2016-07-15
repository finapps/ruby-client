module FinApps
  module Middleware
    # This middleware sets the User-Agent request-header field to identify thei client.
    # If the value for this header already exists, it is not overriden.
    class UserAgent < Faraday::Middleware
      KEY = 'User-Agent'.freeze unless defined? KEY
      RUBY = "#{RUBY_ENGINE}/#{RUBY_PLATFORM} #{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}".freeze

      def call(env)
        env[:request_headers][KEY] ||= "finapps-ruby/#{FinApps::VERSION} (#{RUBY})"
        @app.call(env)
      end
    end
  end
end
