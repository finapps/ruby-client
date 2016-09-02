# frozen_string_literal: true
module FinApps
  module Middleware
    class CustomLogger < Faraday::Response::Middleware
      extend Forwardable
      include FinApps::Utils::ParameterFilter

      DEFAULT_OPTIONS = {bodies: false}.freeze

      def initialize(app, logger=nil, options={})
        super(app)
        @logger = logger || begin
          require 'logger'
          ::Logger.new(STDOUT)
        end
        @options = DEFAULT_OPTIONS.merge(options)
      end

      def_delegators :@logger, :debug, :info, :warn, :error, :fatal

      def call(env)
        info "##{__method__} => ##{env.method} #{env.url}"
        debug "##{__method__} => Request Headers: #{dump_headers env.request_headers}"

        super
      end

      def on_complete(env)
        info "##{__method__} => ##{env.method} #{env.url}"
        debug "##{__method__} => Response Headers: #{dump_headers env.response_headers}"
        info "##{__method__} => Response Body: #{dump_body env.body}" if env.body
      end

      private

      def dump_headers(headers)
        headers.map {|k, v| "  #{k}: #{filter_sensitive_header_values(k, v)}" }.to_s
      end

      def filter_sensitive_header_values(key, value)
        case key
        when 'X-FinApps-Token', 'Authorization'
          '[REDACTED]'
        else
          value.inspect
        end
      end

      def dump_body(body)
        skip_sensitive_data(body)
      end
    end
  end
end
