# frozen_string_literal: true
module StringExtensions
  refine String do
    def json_to_hash
      ::JSON.parse(self)
    rescue ::JSON::ParserError
      # logger.error "##{__method__} => Unable to parse JSON response."
    end
  end
end
