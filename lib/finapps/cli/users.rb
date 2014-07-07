require 'thor'
require 'finapps'
require 'securerandom'
require 'pp'

module FinApps
  class CLI < Thor

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
          puts 'unable to create user'
          error_messages.each { |m| puts m } if error_messages.present?
        end
        puts

      rescue StandardError => error
        rescue_standard_error(error)
      end

    end

    desc 'user_login', 'creates a new API user and signs in'

    def user_login(email=nil, password=nil)

      begin
        email ||= "test-#{SecureRandom.uuid}@powerwallet.com"
        password ||= 'WrongPassword'
        user, error_messages = client.users.login ({:email => email, :password => password})
        if user.present?
          puts
          puts 'user logged in:'
          pp user
        else
          puts
          puts 'unable to login user'
          error_messages.each { |m| puts m } if error_messages.present?
        end
        puts

      rescue StandardError => error
        rescue_standard_error(error)
      end

    end

    desc 'user_delete', 'deletes an API user'

    def user_delete(public_id=nil)

      begin
        public_id ||= SecureRandom.uuid.to_s

        error_messages = client.users.delete (public_id)
        if error_messages.blank?
          puts
          puts 'user deleted!'
        else
          puts
          puts 'unable to delete user'
          error_messages.each { |m| puts m }
        end
        puts

      rescue StandardError => error
        rescue_standard_error(error)
      end

    end

  end
end