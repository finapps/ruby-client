module FinApps
  module REST
    module Defaults

      API_VERSION = '1'

      HEADERS = {
          :accept => 'application/json',
          :user_agent => "finapps-ruby/#{FinApps::VERSION} (#{RUBY_ENGINE}/#{RUBY_PLATFORM} #{RUBY_VERSION}-p#{RUBY_PATCHLEVEL})"
      }.freeze

      # noinspection SpellCheckingInspection
      DEFAULTS = {
          :host => 'https://www.financialapps.com',
          :timeout => 30,
          :proxy_addr => nil,
          :proxy_port => nil,
          :proxy_user => nil,
          :proxy_pass => nil,
          :retry_limit => 1,
          :log_level => Logger::INFO
      }


      END_POINTS = {
          :users_create => 'users/new',
          :users_login => 'users/login',
          :users_delete => 'users/:public_id/delete',
          :institutions_search => 'institutions/:search_term/search',
          :institutions_form => 'institutions/:site_id/form',
          :user_institutions_add => 'institutions/:site_id/add',
          :accounts_list => 'accounts/list'
      }.freeze

    end
  end
end