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
          :users_delete => 'users/:public_id/delete',
          :users_login => 'users/login',


          :institutions_list => 'institutions/:search_term/search',
          :institutions_form => 'institutions/:site_id/form',

          :user_institutions_list => 'institutions/user',
          :user_institutions_add => 'institutions/:site_id/add',
          :user_institutions_show => 'institutions/user/:user_institution_id',
          :user_institutions_status => 'institutions/user/:user_institution_id/status',
          :user_institutions_refresh => 'institutions/user/refresh',

          :transactions_show => 'transaction/:transaction_id',
          :transactions_list => 'transactions/search',
          :transactions_edit => 'transactions/edit',

          :categories_list => 'categories',
          :categories_new => 'categories',
          :categories_edit => 'categories',
          :categories_show => 'categories/:category_id',
          :categories_delete => 'categories/:category_id',

          :geo_record_by_ip_address => 'geo/maxmind/record/:ip_address',
          :geo_record_by_region => 'geo/maxmind/record/:region/:city',
          :geo_postal_record_by_region => 'geo/maxmind/postal/:region/:city',
          :geo_postal_record_by_postal_code => 'geo/maxmind/postal/:postal',
          :geo_us_record_by_region => 'geo/us/region/:region/:city',

          :relevance_rulesets_list => 'relevance/ruleset/names',
          :relevance_rulesets_show => 'relevance/ruleset/:ruleset_name',
          :relevance_rulesets_run => 'relevance/run',

          :inventory_feeds_list => 'inventory/feed/names',
          :inventory_feed_show => 'inventory/feed/:feed_name',

          :inventory_feed_categories_list => 'inventory/feed/categories/unique/:feed_name',
          :inventory_feed_categories_list_by_region => 'inventory/feed/categories/unique/:feed_name/:region/:city'


      }.freeze

    end
  end
end