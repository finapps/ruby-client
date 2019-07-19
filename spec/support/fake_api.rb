# frozen_string_literal: true

require 'sinatra/base'

# the FakeApi class is used to mock API requests while testing.
class FakeApi < Sinatra::Base
  def self.version_path
    "v#{FinAppsCore::REST::Defaults::API_VERSION}"
  end

  # resource
  post("/#{version_path}/resources") { json_response 201, 'resource.json' }
  get("/#{version_path}/resources/:id") { json_response 200, 'resource.json' }
  get("/#{version_path}/resources") { json_response 200, 'resources.json' }
  put("/#{version_path}/resources") { json_response 201, 'resource.json' }
  delete("/#{version_path}/resources/:id") { status 202 }

  # plaid
  post("/#{version_path}/p/webhook") do
    tenant_token = request.env['HTTP_X_TENANT_TOKEN']
    if tenant_token == 'invalid_tenant_token'
      json_response 404, 'resource_not_found.json'
    else
      json_response 200, 'plaid/webhook.json'
    end
  end

  # version
  get("/#{version_path}/version") { 'Version => 2.1.29-.20161208.172810' }

  # tenants
  get("/#{version_path}/settings/tenant") { json_response 200, 'tenant_settings.json' }
  put("/#{version_path}/settings/tenant") do
    request.body.rewind
    request_payload = JSON.parse request.body.read
    if request_payload['bad_params']
      json_response 404, 'resource_not_found.json'
    else
      status 204
    end
  end
  get("/#{version_path}/settings/app") { json_response 200, 'tenant_app_settings.json' }
  put("/#{version_path}/settings/app") do
    request.body.rewind
    request_payload = JSON.parse request.body.read
    if request_payload['pdf_statement_months']
      status 204
    else
      json_response 404, 'resource_not_found.json'
    end
  end

  # orders
  post("/#{version_path}/orders/valid_token") { json_response 200, 'order_token.json' }
  post("/#{version_path}/orders/invalid_token") { json_response 404, 'resource_not_found.json' }
  get("/#{version_path}/orders/valid_id") { json_response 200, 'order.json' }
  get("/#{version_path}/orders") { json_response 200, 'orders.json' }
  get("/#{version_path}/orders/valid_id/report.:format") { json_response 200, 'order_report.json' }
  get("/#{version_path}/orders/invalid_id/report.:format") { json_response 404, 'resource_not_found.json' }
  get("/#{version_path}/orders/valid_id/status") { json_response 200, 'order_status.json' }
  get("/#{version_path}/orders/invalid_id/status") { json_response 404, 'resource_not_found.json' }
  put("/#{version_path}/orders/valid_id/cancel") { status 204 }
  put("/#{version_path}/orders/invalid_id/cancel") { json_response 404, 'resource_not_found.json' }
  put("/#{version_path}/orders/valid_id/notify") { status 204 }
  put("/#{version_path}/orders/invalid_id/notify") { json_response 404, 'resource_not_found.json' }
  put("/#{version_path}/orders/valid_id/refresh") { json_response 200, 'order_refresh.json' }
  put("/#{version_path}/orders/invalid_id/refresh") { json_response 404, 'resource_not_found.json' }
  put("/#{version_path}/orders/invalid_id") { json_response 404, 'resource_not_found.json' }
  put("/#{version_path}/orders/valid_id") do
    request.body.rewind
    request_payload = JSON.parse request.body.read
    if request_payload['accounts'] == 'valid_account'
      status 204
    else
      json_response 400, 'invalid_request_body.json'
    end
  end
  post("/#{version_path}/orders") do
    request.body.rewind
    request_payload = JSON.parse request.body.read
    if %w[applicant institutions product].all? {|s| request_payload.key? s }
      json_response 200, 'order_token.json'
    else
      json_response 400, 'invalid_request_body.json'
    end
  end

  # institutions
  get("/#{version_path}/institutions/site/valid_site_id/form") { json_response 200, 'institution_login_form.json' }
  get("/#{version_path}/institutions/site/invalid_site_id/form") { json_response 400, 'invalid_institution_id.json' }
  post("/#{version_path}/institutions/site/valid_site_id/add") { json_response 200, 'institution_add.json' }
  get("/#{version_path}/institutions/search/:search_term") { json_response 200, 'institutions_search_list.json' }
  get("/#{version_path}/institutions/routing/:routing_number") { json_response 200, 'institutions_routing_number.json' }
  get("/#{version_path}/institutions/site/:site_id") { json_response 200, 'institutions_routing_number.json' }

  # user institutions
  get("/#{version_path}/institutions/consumer/valid_id/status") { json_response 200, 'user_institution_status.json' }
  get("/#{version_path}/institutions/consumer/invalid_id/status") do
    json_response 400, 'invalid_user_institution_id.json'
  end
  get("/#{version_path}/institutions/consumer") { json_response 200, 'user_institutions_list.json' }
  get("/#{version_path}/institutions/consumer/valid_id") { json_response 200, 'user_institutions_show.json' }
  get("/#{version_path}/institutions/consumer/invalid_id") { json_response 400, 'invalid_user_institution_id.json' }
  put("/#{version_path}/institutions/consumer/refresh") { json_response 200, 'user_institutions_refresh_all.json' }
  put("/#{version_path}/institutions/consumer/valid_id/credentials") { json_response 200, 'institution_add.json' }
  put("/#{version_path}/institutions/consumer/invalid_id/credentials") do
    json_response 400, 'invalid_user_institution_id.json'
  end
  put("/#{version_path}/institutions/consumer/valid_id/mfa") { json_response 200, 'institution_add.json' }
  put("/#{version_path}/institutions/consumer/invalid_id/mfa") { json_response 400, 'invalid_user_institution_id.json' }
  delete("/#{version_path}/institutions/consumer/valid_id") { status 204 }
  delete("/#{version_path}/institutions/consumer/invalid_id") { json_response 400, 'invalid_user_institution_id.json' }
  get("/#{version_path}/institutions/consumer/valid_id/form") { json_response 200, 'institution_login_form.json' }
  get("/#{version_path}/institutions/consumer/invalid_id/form") { json_response 400, 'invalid_institution_id.json' }
  put("/#{version_path}/institutions/refresh") { json_response 200, 'user_institution_refresh.json' }
  put("/#{version_path}/institutions/consumer/valid_consumer_institution_id/refresh") do
    request.body.rewind
    request_payload = JSON.parse request.body.read
    if request_payload['token'] == 'invalid_token'
      json_response(400, 'refresh_invalid_mfa.json')
    else
      json_response(200, 'refresh_queued.json')
    end
  end

  # consumers
  get("/#{version_path}/consumers/valid_public_id") { json_response 200, 'user.json' }
  get("/#{version_path}/consumers/invalid_public_id") { json_response 404, 'resource_not_found.json' }
  post("/#{version_path}/consumers") do
    request.body.rewind
    request_payload = JSON.parse request.body.read
    if request_payload['password']
      json_response 201, 'user.json'
    else
      json_response 400, 'invalid_request_body.json'
    end
  end
  put("/#{version_path}/consumers/valid_public_id") { status 204 }
  put("/#{version_path}/consumers/invalid_public_id") { json_response 400, 'invalid_user_id.json' }
  put("/#{version_path}/consumers/valid_public_id/password") { json_response 200, 'user.json' }
  put("/#{version_path}/consumers/invalid_public_id/password") { json_response 404, 'resource_not_found.json' }
  delete("/#{version_path}/consumers/valid_public_id") { status 204 }
  delete("/#{version_path}/consumers/invalid_public_id") { json_response 404, 'resource_not_found.json' }
  post("/#{version_path}/logout") { status 204 }

  # accounts
  get("/#{version_path}/accounts/valid_id/statement/valid_id") { json_response 200, 'fake_pdf_statement.json' }
  get("/#{version_path}/accounts/invalid_id/statement/valid_id") { json_response 404, 'resource_not_found.json' }

  # operators
  get("/#{version_path}/operators") { json_response 200, 'operator_list.json' }
  get("/#{version_path}/operators/invalid_id") { json_response 404, 'resource_not_found.json' }
  get("/#{version_path}/operators/valid_id") { json_response 200, 'operator.json' }
  delete("/#{version_path}/operators/invalid_id") { json_response 404, 'resource_not_found.json' }
  delete("/#{version_path}/operators/valid_id") { status 204 }
  post("/#{version_path}/operators/password/change") { json_response 200, 'operator.json' }
  put("/#{version_path}/operators/invalid_id") { json_response 404, 'resource_not_found.json' }
  put("/#{version_path}/operators/valid_id") { json_response 200, 'operator.json' }
  put("/#{version_path}/operators/valid_id/assign") { status 204 }
  put("/#{version_path}/operators/invalid_id/assign") { json_response 404, 'resource_not_found.json' }
  post("/#{version_path}/operators/password/forgot") { json_response 200, 'operator_forgot_password.json' }
  post("/#{version_path}/operators/password/reset")  do
    request.body.rewind
    request_payload = JSON.parse request.body.read
    if request_payload['params'] == 'valid'
      json_response 200, 'operator.json'
    else
      json_response 400, 'invalid_request_body.json'
    end
  end
  post("/#{version_path}/operators") do
    request.body.rewind
    request_payload = JSON.parse request.body.read
    if request_payload['params'] == 'valid'
      json_response 201, 'operator.json'
    else
      json_response 400, 'invalid_request_body.json'
    end
  end

  # session
  post("/#{version_path}/login") do
    request.body.rewind
    request_payload = JSON.parse request.body.read
    if request_payload['password'] == 'valid_password'
      json_response(200, 'user.json')
    else
      json_response(401, 'unauthorized.json')
    end
  end
  post("/#{version_path}/operators/login") { json_response 200, 'operator.json' }

  # password resets
  post("/#{version_path}/tenant/valid_user_id/password") { json_response 200, 'password_reset_token.json' }
  post("/#{version_path}/tenant/invalid_user_id/password") { json_response 404, 'resource_not_found.json' }
  put("/#{version_path}/tenant/valid_user_id/password") do
    request.body.rewind
    request_payload = JSON.parse request.body.read
    if request_payload['token'] == 'valid_token'
      json_response(200, 'user.json')
    else
      json_response(400, 'invalid_request_body.json')
    end
  end
  put("/#{version_path}/tenant/invalid_user_id/password") { json_response 404, 'resource_not_found.json' }

  # products
  get("/#{version_path}/products") { json_response 200, 'products.json' }

  # portfolios
  get("/#{version_path}/portfolios") { json_response 200, 'portfolios.json' }
  get("/#{version_path}/portfolios/valid_id") { json_response 200, 'portfolio.json' }
  get("/#{version_path}/portfolios/invalid_id") { json_response 404, 'resource_not_found.json' }
  post("/#{version_path}/portfolios") do
    request.body.rewind
    request_payload = JSON.parse request.body.read
    if request_payload['product'] == 'invalid'
      json_response(400, 'invalid_request_body.json')
    else
      json_response(200, 'portfolio.json')
    end
  end
  put("/#{version_path}/portfolios/valid_id") { json_response 200, 'portfolio.json' }
  put("/#{version_path}/portfolios/invalid_id") { json_response 404, 'resource_not_found.json' }
  delete("/#{version_path}/portfolios/valid_id") { status 204 }
  delete("/#{version_path}/portfolios/invalid_id") { json_response 404, 'resource_not_found.json' }

  # alert definitions
  get("/#{version_path}/portfolio/alerts/definitions") { json_response 200, 'alert_definitions.json' }
  get("/#{version_path}/portfolio/alerts/definitions/valid_id") { json_response 200, 'alert_definition.json' }
  get("/#{version_path}/portfolio/alerts/definitions/invalid_id") { json_response 404, 'resource_not_found.json' }

  # alert occurrences
  get("/#{version_path}/portfolio/alerts/occurrences") { json_response 200, 'alert_occurrences.json' }

  # portfolios alerts
  get("/#{version_path}/portfolios/valid_id/alerts") { json_response 200, 'portfolios_alerts.json' }
  get("/#{version_path}/portfolios/invalid_id/alerts") { json_response 404, 'resource_not_found.json' }
  put("/#{version_path}/portfolios/valid_id/alerts/valid_id") { status 204 }
  put("/#{version_path}/portfolios/invalid_id/alerts/invalid_id") { json_response 404, 'resource_not_found.json' }
  delete("/#{version_path}/portfolios/valid_id/alerts/valid_id") { status 204 }
  delete("/#{version_path}/portfolios/invalid_id/alerts/invalid_id") { json_response 404, 'resource_not_found.json' }

  # portfolios consumers
  get("/#{version_path}/portfolios/valid_id/consumers") { json_response 200, 'portfolios_consumers.json' }
  get("/#{version_path}/portfolios/invalid_id/consumers") { json_response 404, 'resource_not_found.json' }
  post("/#{version_path}/portfolios/valid_id/consumers") { status 204 }
  post("/#{version_path}/portfolios/invalid_id/consumers") do
    json_response 400, 'multiple_consumer_subscribe_error.json'
  end
  post("/#{version_path}/portfolios/valid_id/consumers/valid_id") { status 204 }
  post("/#{version_path}/portfolios/invalid_id/consumers/invalid_id") do
    json_response 400, 'single_consumer_subscribe_error.json'
  end
  delete("/#{version_path}/portfolios/valid_id/consumers/valid_id") { status 204 }
  delete("/#{version_path}/portfolios/invalid_id/consumers/invalid_id") { json_response 404, 'resource_not_found.json' }

  # portfolios available consumers
  get("/#{version_path}/portfolios/:id/consumers/available") do
    json_response 200, 'portfolios_available_consumers.json'
  end

  # consumers portfolios
  get("/#{version_path}/consumers/valid_id/portfolios") { json_response 200, 'portfolios.json' }
  get("/#{version_path}/consumers/invalid_id/portfolios") { json_response 404, 'resource_not_found.json' }

  # portfolio reports
  get("/#{version_path}/portfolio/reports") { json_response 200, 'portfolio_reports.json' }

  # relevance
  get("/#{version_path}/relevance/ruleset/names") { json_response 200, 'relevance_ruleset_names.json' }

  # errors
  get("/#{version_path}/client_error") { json_response 400, 'error.json' }
  get("/#{version_path}/server_error") { status 500 }
  get("/#{version_path}/proxy_error") { status 407 }

  # timeout
  get("/#{version_path}/orders/timeout") { status 419 }

  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read
  end
end
