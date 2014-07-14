require 'thor'
require 'finapps'


module FinApps
  class CLI < Thor

    desc 'create_client', 'initialize API REST Client'

    def create_client
      puts client
    end

    private

    def client
      company_id = ENV['FA_ID']
      raise 'Invalid company identifier. Please setup the FA_ID environment variable.' if company_id.blank?

      company_token = ENV['FA_TOKEN']
      raise 'Invalid company token. Please setup the FA_TOKEN environment variable.' if company_token.blank?

      host = ENV['FA_URL']
      raise 'Invalid API host url. Please setup the FA_URL environment variable.' if host.blank?

      @client ||= FinApps::REST::Client.new company_id, company_token, {:host => host, :log_level => Logger::DEBUG,
                                                                        :request_uuid => 'le-request-uuid-z',
                                                                        :session_id => 'da-session-idz'}
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