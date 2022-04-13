# frozen_string_literal: true

module FinApps
  module REST
    class Locations < FinAppsCore::REST::Resources # :nodoc:
      def list(filter = nil)
        path = "#{end_point}?filter=#{filter}" unless filter.nil?
        super path
      end

      def update(id, params)
        path = resource_path(id)
        super params, path
      end
    end
  end
end
