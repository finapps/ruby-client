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


    desc 'institutions_refresh', 'refresh institutions'

    def institutions_refresh(user_identifier, user_token = '4JZmhcHVf3ODRJ9TMKF7N/1sHDY3M5Q49A9ToAy+TDE=', term=nil)

      begin
        client.user_credentials!(user_identifier, user_token)
        results, error_messages = client.user_institutions.refresh
        if results.present?
          puts
          puts 'refresh results:'
          pp results
        else
          puts
          puts 'unable to refresh institutions'
          error_messages.each { |m| puts m } if error_messages.present?
        end
        puts

      rescue StandardError => error
        rescue_standard_error(error)
      end

    end

  end
end