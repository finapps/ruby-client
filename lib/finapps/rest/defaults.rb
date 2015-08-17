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
          :users_update => 'user',
          :users_delete => 'users/:public_id',
          :users_login => 'users/login',

          :relevance_rulesets_list => 'relevance/ruleset/names',
          :relevance_rulesets_show => 'relevance/ruleset/:ruleset_name',
          :relevance_rulesets_run => 'relevance/run',

          :institutions_list => 'institutions/:search_term/search',
          :institutions_form => 'institutions/:site_id/form',

          :user_institutions_list => 'institutions/user',
          :user_institutions_add => 'institutions/:site_id/add',
          :user_institutions_show => 'institutions/user/:user_institution_id',
          :user_institutions_update => 'institutions/user/:user_institution_id/credentials',
          :user_institutions_delete => 'institutions/user/:user_institution_id',
          :user_institutions_status => 'institutions/user/:user_institution_id/status',
          :user_institutions_mfa => 'institutions/user/:user_institution_id/mfa',
          :user_institutions_refresh => 'institutions/user/refresh',
          :user_institutions_form => 'institutions/user/:user_institution_id/form',

          :transactions_show => 'transaction/:transaction_id',
          :transactions_list => 'transactions/search',
          :transactions_update => 'transactions/edit',

          :categories_list => 'categories',
          :categories_new => 'categories',
          :categories_update => 'categories',
          :categories_show => 'categories/:category_id',
          :categories_delete => 'categories/:category_id',

          :budget_models_list => 'budget/templates',
          :budget_models_show => 'budget/template/:budget_model_id',

          :budget_calculation_create => 'budget/template/:budget_model_id/:income',
          :budget_calculation_show => 'categories',

          :budget_update => 'budget',
          :budget_show => 'budget/:start_date/:end_date',

          :cashflow_show => 'cashflow/:start_date/:end_date',

          :alert_list => 'alerts/:page/:requested/:sort/:asc/:read',
          :alert_update => 'alerts/:alert_id/:read',
          :alert_delete => 'alerts/:alert_id',

          :alert_definition_list => 'alerts/definitions',
          :alert_definition_show => 'alerts/definitions/:alert_name',

          :alert_settings_show => 'alerts/settings',
          :alert_settings_update => 'alerts/settings',

          :alert_preferences_show => 'alerts/preferences',
          :alert_preferences_update => 'alerts/preferences'


      }.freeze

    end
  end
end