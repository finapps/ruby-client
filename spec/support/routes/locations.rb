# frozen_string_literal: true

module Fake
  module LocationsRoutes
    class << self
      def included(base)
        base.get("/#{base.version}/locations") do
          json_response 200, 'locations/get_locations.json'
        end
        super
      end
    end
  end
end
