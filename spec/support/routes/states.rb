# frozen_string_literal: true

module Fake
  module StateRoutes
    class << self
      def included(base)
        base.get("/#{base.version}/references/states") do
          json_response 200, 'states/get_states.json'
        end
        super
      end
    end
  end
end
