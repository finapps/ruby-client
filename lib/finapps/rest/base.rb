module FinApps
  module REST
    class Base

      # @param [Hash] h
      def update_from_hash(h)
        h.each { |k, v| instance_variable_set("@#{k}", v) unless v.nil? }
        self
      end

    end
  end
end