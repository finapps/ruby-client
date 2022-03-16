# frozen_string_literal: true

module FinApps
  module REST
    class Locations < FinAppsCore::REST::Resources # :nodoc:
      def list(filter = nil)
        path = "#{end_point}?filter=#{filter}" unless filter.nil?
        super path
      end

      def update(key, params = {})
        path = resource_path(key)
        send_request path, :put, params
      end
    end
  end
end
