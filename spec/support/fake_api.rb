# frozen_string_literal: true

require 'sinatra/base'

# the FakeApi class is used to mock API requests while testing.
class FakeApi < Sinatra::Base
  # resource
  post('/v3/resources') { json_response 201, 'resource.json' }
  get('/v3/resources/:id') { json_response 200, 'resource.json' }
  get('/v3/resources') { json_response 200, 'resources.json' }
  put('/v3/resources') { json_response 201, 'resource.json' }
  delete('/v3/resources/:id') { status 202 }

  # plaid
  post('/v3/p/webhook') do
    # 'X-Tenant-Token'=>'invalid_tenant_token'
    if request.env['X-Tenant-Token'] == 'invalid_tenant_token'
      json_response 404, 'resource_not_found.json'
    else
      json_response 200, 'plaid/webhook.json'
    end
  end

  # version
  get('/v3/version') { 'Version => 2.1.29-.20161208.172810' }

  # tenants
  get('/v3/settings/tenant') { json_response 200, 'tenant_settings.json' }
  put('/v3/settings/tenant') do
    request.body.rewind
    request_payload = JSON.parse request.body.read
    if request_payload['bad_params']
      json_response 404, 'resource_not_found.json'
    else
      status 204
    end
  end
  get('/v3/settings/app') { json_response 200, 'tenant_app_settings.json' }
  put('/v3/settings/app') do
    request.body.rewind
    request_payload = JSON.parse request.body.read
    if request_payload['pdf_statement_months']
      status 204
    else
      json_response 404, 'resource_not_found.json'
    end
  end

  # orders
  post('/v3/orders/valid_token') { json_response 200, 'order_token.json' }
  post('/v3/orders/invalid_token') { json_response 404, 'resource_not_found.json' }
  get('/v3/orders/valid_id') { json_response 200, 'order.json' }
  get('/v3/orders') { json_response 200, 'orders.json' }
  get('/v3/orders/valid_id/report.:format') { json_response 200, 'order_report.json' }
  get('/v3/orders/invalid_id/report.:format') { json_response 404, 'resource_not_found.json' }
  get('/v3/orders/valid_id/status') { json_response 200, 'order_status.json' }
  get('/v3/orders/invalid_id/status') { json_response 404, 'resource_not_found.json' }
  put('/v3/orders/valid_id/cancel') { status 204 }
  put('/v3/orders/invalid_id/cancel') { json_response 404, 'resource_not_found.json' }
  put('/v3/orders/valid_id/notify') { status 204 }
  put('/v3/orders/invalid_id/notify') { json_response 404, 'resource_not_found.json' }
  put('/v3/orders/valid_id/refresh') { json_response 200, 'order_refresh.json' }
  put('/v3/orders/invalid_id/refresh') { json_response 404, 'resource_not_found.json' }
  put('/v3/orders/invalid_id') { json_response 404, 'resource_not_found.json' }
  put('/v3/orders/valid_id') do
    request.body.rewind
    request_payload = JSON.parse request.body.read
    if request_payload['accounts'] == 'valid_account'
      status 204
    else
      json_response 400, 'invalid_request_body.json'
    end
  end
  post('/v3/orders') do
    request.body.rewind
    request_payload = JSON.parse request.body.read
    if %w[applicant institutions product].all? {|s| request_payload.key? s }
      json_response 200, 'order_token.json'
    else
      json_response 400, 'invalid_request_body.json'
    end
  end

  # institutions
  get('/v3/institutions/site/valid_site_id/form') { json_response 200, 'institution_login_form.json' }
  get('/v3/institutions/site/invalid_site_id/form') { json_response 400, 'invalid_institution_id.json' }
  post('/v3/institutions/site/valid_site_id/add') { json_response 200, 'institution_add.json' }
  get('/v3/institutions/search/:search_term') { json_response 200, 'institutions_search_list.json' }
  get('/v3/institutions/routing/:routing_number') { json_response 200, 'institutions_routing_number.json' }
  get('/v3/institutions/site/:site_id') { json_response 200, 'institutions_routing_number.json' }

  # user institutions
  get('/v3/institutions/consumer/valid_id/status') { json_response 200, 'user_institution_status.json' }
  get('/v3/institutions/consumer/invalid_id/status') { json_response 400, 'invalid_user_institution_id.json' }
  get('/v3/institutions/consumer') { json_response 200, 'user_institutions_list.json' }
  get('/v3/institutions/consumer/valid_id') { json_response 200, 'user_institutions_show.json' }
  get('/v3/institutions/consumer/invalid_id') { json_response 400, 'invalid_user_institution_id.json' }
  put('/v3/institutions/consumer/refresh') { json_response 200, 'user_institutions_refresh_all.json' }
  put('/v3/institutions/consumer/valid_id/credentials') { json_response 200, 'institution_add.json' }
  put('/v3/institutions/consumer/invalid_id/credentials') { json_response 400, 'invalid_user_institution_id.json' }
  put('/v3/institutions/consumer/valid_id/mfa') { json_response 200, 'institution_add.json' }
  put('/v3/institutions/consumer/invalid_id/mfa') { json_response 400, 'invalid_user_institution_id.json' }
  delete('/v3/institutions/consumer/valid_id') { status 204 }
  delete('/v3/institutions/consumer/invalid_id') { json_response 400, 'invalid_user_institution_id.json' }
  get('/v3/institutions/consumer/valid_id/form') { json_response 200, 'institution_login_form.json' }
  get('/v3/institutions/consumer/invalid_id/form') { json_response 400, 'invalid_institution_id.json' }
  put('/v3/institutions/refresh') { json_response 200, 'user_institution_refresh.json' }
  put('/v3/institutions/consumer/valid_consumer_institution_id/refresh') do
    request.body.rewind
    request_payload = JSON.parse request.body.read
    if request_payload['token'] == 'invalid_token'
      json_response(400, 'refresh_invalid_mfa.json')
    else
      json_response(200, 'refresh_queued.json')
    end
  end

  # consumers
  get('/v3/consumers/valid_public_id') { json_response 200, 'user.json' }
  get('/v3/consumers/invalid_public_id') { json_response 404, 'resource_not_found.json' }
  post('/v3/consumers') do
    request.body.rewind
    request_payload = JSON.parse request.body.read
    if request_payload['password']
      json_response 201, 'user.json'
    else
      json_response 400, 'invalid_request_body.json'
    end
  end
  put('/v3/consumers/valid_public_id') { status 204 }
  put('/v3/consumers/invalid_public_id') { json_response 400, 'invalid_user_id.json' }
  put('/v3/consumers/valid_public_id/password') { json_response 200, 'user.json' }
  put('/v3/consumers/invalid_public_id/password') { json_response 404, 'resource_not_found.json' }
  delete('/v3/consumers/valid_public_id') { status 204 }
  delete('/v3/consumers/invalid_public_id') { json_response 404, 'resource_not_found.json' }
  post('/v3/logout') { status 204 }

  # accounts
  get('/v3/accounts/valid_id/statement/valid_id') { json_response 200, 'fake_pdf_statement.json' }
  get('/v3/accounts/invalid_id/statement/valid_id') { json_response 404, 'resource_not_found.json' }

  # operators
  get('/v3/operators') { json_response 200, 'operator_list.json' }
  get('/v3/operators/invalid_id') { json_response 404, 'resource_not_found.json' }
  get('/v3/operators/valid_id') { json_response 200, 'operator.json' }
  delete('/v3/operators/invalid_id') { json_response 404, 'resource_not_found.json' }
  delete('/v3/operators/valid_id') { status 204 }
  post('/v3/operators/password/change') { json_response 200, 'operator.json' }
  put('/v3/operators/invalid_id') { json_response 404, 'resource_not_found.json' }
  put('/v3/operators/valid_id') { json_response 200, 'operator.json' }
  put('/v3/operators/valid_id/assign') { status 204 }
  put('/v3/operators/invalid_id/assign') { json_response 404, 'resource_not_found.json' }
  post('/v3/operators/password/forgot') { json_response 200, 'operator_forgot_password.json' }
  post('/v3/operators/password/reset')  do
    request.body.rewind
    request_payload = JSON.parse request.body.read
    if request_payload['params'] == 'valid'
      json_response 200, 'operator.json'
    else
      json_response 400, 'invalid_request_body.json'
    end
  end
  post('/v3/operators') do
    request.body.rewind
    request_payload = JSON.parse request.body.read
    if request_payload['params'] == 'valid'
      json_response 201, 'operator.json'
    else
      json_response 400, 'invalid_request_body.json'
    end
  end

  # session
  post('/v3/login') do
    request.body.rewind
    request_payload = JSON.parse request.body.read
    if request_payload['password'] == 'valid_password'
      json_response(200, 'user.json')
    else
      json_response(401, 'unauthorized.json')
    end
  end
  post('/v3/operators/login') { json_response 200, 'operator.json' }

  # password resets
  post('/v3/tenant/valid_user_id/password') { json_response 200, 'password_reset_token.json' }
  post('/v3/tenant/invalid_user_id/password') { json_response 404, 'resource_not_found.json' }
  put('/v3/tenant/valid_user_id/password') do
    request.body.rewind
    request_payload = JSON.parse request.body.read
    if request_payload['token'] == 'valid_token'
      json_response(200, 'user.json')
    else
      json_response(400, 'invalid_request_body.json')
    end
  end
  put('/v3/tenant/invalid_user_id/password') { json_response 404, 'resource_not_found.json' }

  # products
  get('/v3/products') { json_response 200, 'products.json' }

  # portfolios
  get('/v3/portfolios') { json_response 200, 'portfolios.json' }
  get('/v3/portfolios/valid_id') { json_response 200, 'portfolio.json' }
  get('/v3/portfolios/invalid_id') { json_response 404, 'resource_not_found.json' }
  post('/v3/portfolios') do
    request.body.rewind
    request_payload = JSON.parse request.body.read
    if request_payload['product'] == 'invalid'
      json_response(400, 'invalid_request_body.json')
    else
      json_response(200, 'portfolio.json')
    end
  end
  put('/v3/portfolios/valid_id') { json_response 200, 'portfolio.json' }
  put('/v3/portfolios/invalid_id') { json_response 404, 'resource_not_found.json' }
  delete('/v3/portfolios/valid_id') { status 204 }
  delete('/v3/portfolios/invalid_id') { json_response 404, 'resource_not_found.json' }

  # alert definitions
  get('/v3/portfolio/alerts/definitions') { json_response 200, 'alert_definitions.json' }
  get('/v3/portfolio/alerts/definitions/valid_id') { json_response 200, 'alert_definition.json' }
  get('/v3/portfolio/alerts/definitions/invalid_id') { json_response 404, 'resource_not_found.json' }

  # alert occurrences
  get('/v3/portfolio/alerts/occurrences') { json_response 200, 'alert_occurrences.json' }

  # portfolios alerts
  get('/v3/portfolios/valid_id/alerts') { json_response 200, 'portfolios_alerts.json' }
  get('/v3/portfolios/invalid_id/alerts') { json_response 404, 'resource_not_found.json' }
  put('/v3/portfolios/valid_id/alerts/valid_id') { status 204 }
  put('/v3/portfolios/invalid_id/alerts/invalid_id') { json_response 404, 'resource_not_found.json' }
  delete('/v3/portfolios/valid_id/alerts/valid_id') { status 204 }
  delete('/v3/portfolios/invalid_id/alerts/invalid_id') { json_response 404, 'resource_not_found.json' }

  # portfolios consumers
  get('/v3/portfolios/valid_id/consumers') { json_response 200, 'portfolios_consumers.json' }
  get('/v3/portfolios/invalid_id/consumers') { json_response 404, 'resource_not_found.json' }
  post('/v3/portfolios/valid_id/consumers') { status 204 }
  post('/v3/portfolios/invalid_id/consumers') { json_response 400, 'multiple_consumer_subscribe_error.json' }
  post('/v3/portfolios/valid_id/consumers/valid_id') { status 204 }
  post('/v3/portfolios/invalid_id/consumers/invalid_id') { json_response 400, 'single_consumer_subscribe_error.json' }
  delete('/v3/portfolios/valid_id/consumers/valid_id') { status 204 }
  delete('/v3/portfolios/invalid_id/consumers/invalid_id') { json_response 404, 'resource_not_found.json' }

  # portfolios available consumers
  get('/v3/portfolios/:id/consumers/available') { json_response 200, 'portfolios_available_consumers.json' }

  # consumers portfolios
  get('/v3/consumers/valid_id/portfolios') { json_response 200, 'portfolios.json' }
  get('/v3/consumers/invalid_id/portfolios') { json_response 404, 'resource_not_found.json' }

  # portfolio reports
  get('/v3/portfolio/reports') { json_response 200, 'portfolio_reports.json' }

  # relevance
  get('/v3/relevance/ruleset/names') { json_response 200, 'relevance_ruleset_names.json' }

  # errors
  get('/v3/client_error') { json_response 400, 'error.json' }
  get('/v3/server_error') { status 500 }
  get('/v3/proxy_error') { status 407 }

  # timeout
  get('/v3/orders/timeout') { status 419 }

  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read
  end
end
