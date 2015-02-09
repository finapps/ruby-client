require 'thor'
require 'finapps'

# export FINAPPS_COMPANY_IDENTIFIER=2e9cfb18-8ac4-4d9d-5695-aa16154f71f6
# export FINAPPS_COMPANY_TOKEN=uExvlQ0XQBt1PR+Nlfj96pgOMmd9bgKnnWx/kiygmrc=
# export FINAPPS_BASE_URL=https://finapps-qa.herokuapp.com

module FinApps
  class CLI < Thor

    desc 'create_client', 'initialize API REST Client'

    def create_client
      puts client
    end

    private

    def client
      company_id = ENV['FINAPPS_COMPANY_IDENTIFIER']
      raise 'Invalid company identifier. Please setup the FA_ID environment variable.' if company_id.blank?

      company_token = ENV['FINAPPS_COMPANY_TOKEN']
      raise 'Invalid company token. Please setup the FA_TOKEN environment variable.' if company_token.blank?

      host = ENV['FINAPPS_BASE_URL']
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