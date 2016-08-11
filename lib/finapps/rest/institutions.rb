# frozen_string_literal: true
module FinApps
  module REST
    class Institutions < FinApps::REST::Resources
      require 'erb'
      using ObjectExtensions
      using StringExtensions
    end
  end
end
