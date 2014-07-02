module FinApps
  module REST
    module ErrorMessages

      # @param [FinApps::REST::Error] error
      # @return [Array]
      def parse_to_error_messages(error)
        error_messages= Array.new
        if error.respond_to? :response
          if error.response.respond_to? :each_key
            error_messages = error.response[:error_messages]
          end
        end
        error_messages
      end

    end
  end
end


