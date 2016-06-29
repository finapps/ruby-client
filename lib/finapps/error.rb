module FinApps # :nodoc:
  class Error < StandardError; end
  class InvalidArgumentsError < Error; end
  class MissingArgumentsError < Error; end

  %i(InvalidArgumentsError MissingArgumentsError).each {|const| Error.const_set(const, FinApps.const_get(const)) }
end
