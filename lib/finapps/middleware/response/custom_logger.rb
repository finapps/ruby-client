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
        debug "##{__method__} => Request Headers: #{dump env.request_headers}"

        super
      end

      def on_complete(env)
        info "##{__method__} => ##{env.method} #{env.url}"
        debug "##{__method__} => Response Headers: #{dump env.response_headers}"
        info "##{__method__} => Response Body: #{dump env.body}" if env.body
      end

      private

      def dump(value)
        skip_sensitive_data(value.is_a?(Array) ? value.to_h : value).to_json
      end
    end
  end
end
