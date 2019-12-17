# frozen_string_literal: true

module FinApps
  module REST
    class VerixRecords < FinAppsCore::REST::Resources # :nodoc:
      def create(params)
        super(params, 'v/record')
      end

      def list
        super 'v/record'
      end
    end
  end
end
