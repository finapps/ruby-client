module FinApps
  module REST
    class Base

      # @param [Hash] h
      def initialize(h)
        h.each { |k, v| instance_variable_set("@#{k}", v) unless v.nil? } if h.present?
        self
      end

    end
  end
end