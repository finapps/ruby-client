require 'thor'
require 'finapps'
require 'securerandom'
require 'pp'

module FinApps
  class CLI < Thor

    desc 'create_client', 'initialize API REST Client'
    def create_client
      puts client
    end

    desc 'user_create', 'creates a new API user'
    def user_create

      begin
        user = new_user
        puts
        pp user if user.is_valid?
        user.error_messages.each { |m| puts m } if user.error_messages.present?
        puts

      rescue StandardError => error
        rescue_standard_error(error)
      end

    end

    desc 'user_login', 'creates a new API user and signs in'
    def user_login

      begin

        user = new_user
        if user.is_valid?
          logged_user = client.users.login ({:email => user.email, :password => 'Power1'})
          puts
          pp logged_user if logged_user.is_valid?
          logged_user.error_messages.each { |m| puts m } if logged_user.error_messages.present?
          puts
        end

      rescue StandardError => error
        rescue_standard_error(error)
      end

    end

    private
    def new_user
      email = "test-#{SecureRandom.uuid}@powerwallet.com"
      password = 'Power1'
      client.users.create ({:email => email,
                            :password => password,
                            :password_confirm => password,
                            :postal_code => '33021'})
    end

    def client
      company_identifier = '49fb918d-7e71-44dd-7378-58f19606df2a'
      company_token = '7xbgeTqmwyRNGnblofrR0O9uxpShXQEFoNc0DtOkrHo='
      host_url = 'https://finapps-qa.herokuapp.com'

      @client ||= FinApps::REST::Client.new company_identifier, company_token, {:host => host_url}
    end

    def rescue_standard_error(error)
      puts '=============================='
      puts 'Error:'
      p error
      puts '=============================='
    end

  end
end