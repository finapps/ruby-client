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

    def user_create(email=nil, password=nil)

      begin
        email ||= "test-#{SecureRandom.uuid}@powerwallet.com"
        password ||= 'Power1'
        user, error_messages = client.users.create ({:email => email,
                                                     :password => password,
                                                     :password_confirm => password,
                                                     :postal_code => '33021'})
        if user.present?
          puts
          puts 'user created:'
          pp user
        else
          puts
          puts 'unable to create user:'
          error_messages.each { |m| puts m } if error_messages.present?
        end
        puts

      rescue StandardError => error
        rescue_standard_error(error)
      end

    end

    desc 'user_login', 'creates a new API user and signs in'

    def user_login(email, password)

      begin

        user, error_messages = client.users.login ({:email => email, :password => password})
        if user.present?
          puts
          puts 'user logged in:'
          pp user
        else
          puts
          puts 'unable to login user:'
          error_messages.each { |m| puts m } if error_messages.present?
        end
        puts

      rescue StandardError => error
        rescue_standard_error(error)
      end

    end

    private

    def client
      company_id = ENV['FA_ID']
      raise 'Invalid company identifier. Please setup the FA_ID environment variable.' if company_id.blank?

      company_token = ENV['FA_TOKEN']
      raise 'Invalid company token. Please setup the FA_TOKEN environment variable.' if company_token.blank?

      host = ENV['FA_URL']
      raise 'Invalid API host url. Please setup the FA_URL environment variable.' if host.blank?

      @client ||= FinApps::REST::Client.new company_id, company_token, {:host => host}
    end

    def rescue_standard_error(error)
      puts '=============================='
      puts 'Error:'
      p error
      puts "Backtrace:\n\t#{error.backtrace.join("\n\t")}"
      puts '=============================='
    end

  end
end