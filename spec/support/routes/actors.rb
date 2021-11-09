# frozen_string_literal: true

module Fake
  module ActorsRoutes
    class << self
      def included(base)
        base.get("/#{base.version}/actor/details") do
          json_response 200, 'actors/details.json'
        end
        super
      end
    end
  end
end
