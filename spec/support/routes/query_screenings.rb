# frozen_string_literal: true

module Fake
  module QueryScreeningRoutes
    class << self
      def included(base)
        base.post("/#{base.version}/query/screenings") do
          json_response 200, 'query/screenings.json'
        end
        super
      end
    end
  end
end
