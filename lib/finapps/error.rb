# frozen_string_literal: true
# Defines some errors to identify Exceptions within this gem
module FinApps # :nodoc:
  # Base error class.
  class Error < StandardError; end
  # Raised for existing but invalid arguments.
  class InvalidArgumentsError < Error; end
  # Raised whenever a required argument is missing.
  class MissingArgumentsError < Error; end

  # Raised whenever there is a session timeout at the API.
  class ApiSessionTimeoutError < Error; end

  %i(InvalidArgumentsError MissingArgumentsError ApiSessionTimeoutError).each do |const|
    Error.const_set(const, FinApps.const_get(const))
  end
end
