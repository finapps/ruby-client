require 'thor'
require 'finapps'
require 'pp'

module FinApps
  class CLI < Thor

    desc 'budgets', 'show'

    def budgets_show

      begin

        user_identifier = '53d17daf-909d-45d2-6fb6-d43b74d364cb'
        user_token = '4JZmhcHVf3ODRJ9TMKF7N/1sHDY3M5Q49A9ToAy+TDE='

        client.user_credentials!(user_identifier, user_token)
        budget, error_messages = client.budgets.show('2015-01-01T00:00:00Z', '2015-01-31T00:00:00Z')
        if budget.present?
          puts
          puts 'budget results:'
          pp budget
        else
          puts
          puts 'unable to get budgets'
          error_messages.each { |m| puts m } if error_messages.present?
        end
        puts

      rescue StandardError => error
        rescue_standard_error(error)
      end

    end

  end
end