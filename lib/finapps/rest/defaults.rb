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

          :user_institutions_list => 'institutions/user',
          :user_institutions_add => 'institutions/:site_id/add',
          :user_institutions_show => 'institutions/user/:user_institution_id',
          :user_institutions_status => 'institutions/user/:user_institution_id/status',
          :user_institutions_refresh => 'institutions/user/refresh',

          :accounts_show => 'accounts/:account_id/show',

          :transactions_search => 'transactions/search',

          :categories_list => 'categories',

          :geo_record_by_ip_address => 'geo/maxmind/record/:ip_address',
          :geo_record_by_region => 'geo/maxmind/record/:region/:city',
          :geo_postal_record_by_region => 'geo/maxmind/postal/:region/:city',
          :geo_postal_record_by_postal_code => 'geo/maxmind/postal/:postal',
          :geo_us_record_by_region => 'geo/us/region/:region/:city',

          :relevance_ruleset_names => 'relevance/ruleset/names',
          :relevance_ruleset_by_name => 'relevance/ruleset/:ruleset_name',
          :relevance_update_ruleset_script => 'relevance/script/update',
          :relevance_run_ruleset_by_name => 'relevance/run',
          :relevance_run_ruleset_custom => 'relevance/run/custom'

      }.freeze

    end
  end
end