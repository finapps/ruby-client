require 'thor'
require 'finapps'
require 'securerandom'
require 'pp'

module FinApps
  class CLI < Thor

    desc 'institutions_search', 'search institutions'

    def institutions_search(user_identifier, user_token = '4JZmhcHVf3ODRJ9TMKF7N/1sHDY3M5Q49A9ToAy+TDE=', term=nil)

      begin
        client.user_credentials!(user_identifier, user_token)
        institutions, error_messages = client.institutions.search term
        if institutions.present?
          puts
          puts 'search results:'
          pp institutions
        else
          puts
          puts 'unable to search institutions'
          error_messages.each { |m| puts m } if error_messages.present?
        end
        puts

      rescue StandardError => error
        rescue_standard_error(error)
      end

    end

  end
end