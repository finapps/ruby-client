require 'thor'
require 'finapps'
require 'pp'

module FinApps
  class CLI < Thor

    desc 'alert_preferences', 'show'

    def alert_preferences_show

      begin

        user_identifier = '53d17daf-909d-45d2-6fb6-d43b74d364cb'
        user_token = '4JZmhcHVf3ODRJ9TMKF7N/1sHDY3M5Q49A9ToAy+TDE='

        client.user_credentials!(user_identifier, user_token)
        alert_preferences, error_messages = client.alert_preferences.show
        if alert_preferences.present?
          puts
          puts 'alert preferences results:'
          pp alert_preferences
        else
          puts
          puts 'unable to get alert preferences'
          error_messages.each { |m| puts m } if error_messages.present?
        end
        puts

      rescue StandardError => error
        rescue_standard_error(error)
      end

    end

    desc 'alert_preferences_update', 'update'

    def alert_preferences_update

      begin

        user_identifier = '53d17daf-909d-45d2-6fb6-d43b74d364cb'
        user_token = '4JZmhcHVf3ODRJ9TMKF7N/1sHDY3M5Q49A9ToAy+TDE='

        client.user_credentials!(user_identifier, user_token)
        alert_preferences, error_messages = client.alert_preferences.update({:emails => ['user@domain.com'], :phones => []})
        if alert_preferences.present?
          puts
          puts 'alert preferences results:'
          pp alert_preferences
        else
          puts
          puts 'unable to get alert preferences'
          error_messages.each { |m| puts m } if error_messages.present?
        end
        puts

      rescue StandardError => error
        rescue_standard_error(error)
      end

    end

  end
end