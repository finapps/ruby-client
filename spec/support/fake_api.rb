# frozen_string_literal: true

require 'sinatra/base'

# the FakeApi class is used to mock API requests while testing.
class FakeApi < Sinatra::Base
  def self.version
    "v#{FinAppsCore::REST::Defaults::API_VERSION}"
  end

  # resource
  post("/#{version}/resources") { json_response 201, 'resource.json' }
  get("/#{version}/resources/:id") { json_response 200, 'resource.json' }
  get("/#{version}/resources") { json_response 200, 'resources.json' }
  put("/#{version}/resources") { json_response 201, 'resource.json' }
  delete("/#{version}/resources/:id") { status 202 }

  # verix_metadata
  get("/#{version}/v/metadata") do
    json_response 200, 'verix/metadata.json'
  end

  # verix_records
  get("/#{version}/v/record") do
    json_response 200, 'verix/record/list.json'
  end
  post("/#{version}/v/record") do
    json_response 200, 'verix/record/create.json'
  end

  # verix_pdf_documents
  get("/#{version}/v/record/:record_id/file/:provider_id") do
    pdf_response 'verix/document/document.pdf'
  end

  # verix_documents
  get("/#{version}/v/record/:record_id/document") do
    json_response 200, 'verix/document/show.json'
  end
  get("/#{version}/v/record/:record_id/document/:document_id") do
    json_response 200, 'verix/document/list.json'
  end

  # plaid_webhook/metadata
  get("/#{version}/p/metadata") do
    tenant_token = request.env['HTTP_X_TENANT_TOKEN']
    if tenant_token == 'invalid_tenant_token'
      json_response 404, 'invalid_tenant_credentials.json'
    else
      json_response 200, 'plaid/webhook.json'
    end
  end

  # plaid_institution_consumer
  get("/#{version}/p/institution/consumer/:consumer_institution_id") do
    json_response 200, 'plaid/institution/consumer/show.json'
  end
  get("/#{version}/p/institution/consumer/:consumer_institution_id/account") do
    json_response 200, 'plaid/institution/consumer/show_accounts.json'
  end
  get("/#{version}/p/institution/consumer") do
    tenant_token = request.env['HTTP_X_TENANT_TOKEN']
    if tenant_token == 'invalid_tenant_token'
      json_response 404, 'resource_not_found.json'
    else
      json_response 200, 'plaid/institution/consumer/list.json'
    end
  end
  post("/#{version}/p/institution/consumer") do
    tenant_token = request.env['HTTP_X_TENANT_TOKEN']
    if tenant_token == 'invalid_tenant_token'
      json_response 404, 'resource_not_found.json'
    else
      json_response 200, 'plaid/institution/consumer/add.json'
    end
  end
  delete("/#{version}/p/institution/consumer/:consumer_institution_id") do
    status 204
  end
  put("/#{version}/p/institution/consumer/:consumer_institution_id") do
    status 204
  end
  get("/#{version}/p/institution/consumer/:consumer_institution_id/token") do
    json_response 200, 'plaid/institution/consumer/public_token.json'
  end

  # plaid_accounts
  get("/#{version}/p/account") do
    json_response 200, 'plaid/account/list.json'
  end
  get("/#{version}/p/account/:account_id") do
    json_response 200, 'plaid/account/show.json'
  end
  put("/#{version}/p/accounts/permissions") do
    request.body.rewind
    request_payload = JSON.parse request.body.read
    if request_payload.is_a? Array
      status 204
    else
      json_response 400, 'invalid_request_body.json'
    end
  end
  delete("/#{version}/p/accounts/permissions") do
    request.body.rewind
    request_payload = JSON.parse request.body.read
    if request_payload.is_a? Array
      status 204
    else
      json_response 400, 'invalid_request_body.json'
    end
  end

  # plaid_institution_logos
  get("/#{version}/p/institution/logo/:inst_id") do
    png_response 'plaid/institution/logo.png'
  end

  # version
  get("/#{version}/version") { 'Version => 2.1.29-.20161208.172810' }

  # tenants
  get("/#{version}/settings/tenant") do
    json_response 200, 'tenant_settings.json'
  end
  put("/#{version}/settings/tenant") do
    request.body.rewind
    request_payload = JSON.parse request.body.read
    if request_payload['bad_params']
      json_response 404, 'resource_not_found.json'
    else
      status 204
    end
  end
  get("/#{version}/settings/app") do
    json_response 200, 'tenant_app_settings.json'
  end
  put("/#{version}/settings/app") do
    request.body.rewind
    request_payload = JSON.parse request.body.read
    if request_payload['pdf_statement_months']
      status 204
    else
      json_response 404, 'resource_not_found.json'
    end
  end

  # orders
  post("/#{version}/orders/valid_token") do
    json_response 200, 'order_token.json'
  end
  post("/#{version}/orders/invalid_token") do
    json_response 404, 'resource_not_found.json'
  end
  get("/#{version}/orders/valid_id") { json_response 200, 'order.json' }
  get("/#{version}/orders") { json_response 200, 'orders.json' }
  get("/#{version}/orders/valid_id/report.:format") do
    json_response 200, 'order_report.json'
  end
  get("/#{version}/orders/invalid_id/report.:format") do
    json_response 404, 'resource_not_found.json'
  end
  get("/#{version}/orders/valid_id/status") do
    json_response 200, 'order_status.json'
  end
  get("/#{version}/orders/invalid_id/status") do
    json_response 404, 'resource_not_found.json'
  end
  put("/#{version}/orders/valid_id/cancel") { status 204 }
  put("/#{version}/orders/invalid_id/cancel") do
    json_response 404, 'resource_not_found.json'
  end
  put("/#{version}/orders/valid_id/notify") { status 204 }
  put("/#{version}/orders/invalid_id/notify") do
    json_response 404, 'resource_not_found.json'
  end
  put("/#{version}/orders/valid_id/refresh") do
    json_response 200, 'order_refresh.json'
  end
  put("/#{version}/orders/invalid_id/refresh") do
    json_response 404, 'resource_not_found.json'
  end
  put("/#{version}/orders/invalid_id") do
    json_response 404, 'resource_not_found.json'
  end
  put("/#{version}/orders/valid_id") { status 204 }
  put("/#{version}/orders") do
    request.body.rewind
    request_payload = JSON.parse request.body.read
    if request_payload['params'] == 'invalid'
      json_response 400, 'invalid_request_body.json'
    else
      status 204
    end
  end
  post("/#{version}/orders") do
    request.body.rewind
    request_payload = JSON.parse request.body.read
    if %w[applicant institutions product].all? {|s| request_payload.key? s }
      json_response 200, 'order_token.json'
    else
      json_response 400, 'invalid_request_body.json'
    end
  end

  # documents_orders
  get("/#{version}/documents/orders") do
    if params[:filter]&.include?('"status":2')
      json_response 200, 'documents_orders_none.json'
    else
      json_response 200, 'documents_orders.json'
    end
  end
  get("/#{version}/documents/orders/valid_order_id") do
    json_response 200, 'documents_order.json'
  end
  get("/#{version}/documents/orders/invalid_order_id") do
    json_response 404, 'resource_not_found.json'
  end
  post("/#{version}/documents/orders") do
    request.body.rewind
    request_payload = JSON.parse request.body.read
    if %w[applicant esign_documents tag].all? {|s| request_payload.key? s }
      json_response 200, 'documents_order.json'
    else
      json_response 400, 'invalid_request_body.json'
    end
  end
  put("/#{version}/documents/orders/valid_order_id") do
    request.body.rewind
    request_payload = JSON.parse request.body.read
    if request_payload['tag'] == 'invalid'
      json_response 400, 'invalid_request_body.json'
    else
      status 204
    end
  end
  put("/#{version}/documents/orders/invalid_order_id") do
    json_response 400, 'invalid_order_id.json'
  end
  delete("/#{version}/documents/orders/valid_order_id") { status 204 }
  delete("/#{version}/documents/orders/invalid_order_id") do
    json_response 404, 'resource_not_found.json'
  end
  get("/#{version}/documents/orders/valid_order_id/sign_url/valid_signature_id") do
    json_response 200, 'sign_url.json'
  end
  get("/#{version}/documents/orders/invalid_order_id/sign_url/valid_signature_id") do
    json_response 400, 'invalid_order_id.json'
  end
  get("/#{version}/documents/orders/valid_order_id/sign_url/invalid_signature_id") do
    json_response 404, 'invalid_signature_id.json'
  end

  # documents_uploads
  get("/#{version}/consumers/:consumer_id/documents/:doc_id?thumbnail=false") do
    pdf_response 'signed_document.pdf'
  end
  delete("/#{version}/documents/orders/valid_order_id/valid_doc_id") { status 204 }
  delete("/#{version}/documents/orders/valid_order_id/invalid_doc_id") do
    json_response 404, 'resource_not_found.json'
  end
  delete("/#{version}/documents/orders/invalid_order_id/valid_doc_id") do
    json_response 404, 'resource_not_found.json'
  end

  # documents orders notifications
  post("/#{version}/documents/orders/valid_id/notify") { status 204 }
  post("/#{version}/documents/orders/invalid_id/notify") do
    json_response 400, 'invalid_order_id.json'
  end

  # signed documents downloads
  get("/#{version}/consumers/:consumer_id/documents/:signature_request_id") do
    pdf_response 'signed_document.pdf'
  end

  # esign_templates
  get("/#{version}/esign_templates") { json_response 200, 'esign_templates.json' }

  # document_upload_types
  get("/#{version}/documents/upload_types") { json_response 200, 'upload_types.json' }

  # consumers
  get("/#{version}/consumers") do
    json_response 200, 'users.json'
  end
  get("/#{version}/consumers/valid_public_id") do
    json_response 200, 'user.json'
  end
  get("/#{version}/consumers/invalid_public_id") do
    json_response 404, 'resource_not_found.json'
  end
  post("/#{version}/consumers") do
    request.body.rewind
    request_payload = JSON.parse request.body.read
    if request_payload['password']
      json_response 201, 'user.json'
    else
      json_response 400, 'invalid_request_body.json'
    end
  end
  put("/#{version}/consumers/valid_public_id") { status 204 }
  put("/#{version}/consumers/invalid_public_id") do
    json_response 400, 'invalid_user_id.json'
  end
  put("/#{version}/consumers/valid_public_id/password") do
    json_response 200, 'user.json'
  end
  put("/#{version}/consumers/invalid_public_id/password") do
    json_response 404, 'resource_not_found.json'
  end
  delete("/#{version}/consumers/valid_public_id") { status 204 }
  delete("/#{version}/consumers/invalid_public_id") do
    json_response 404, 'resource_not_found.json'
  end
  post("/#{version}/logout") { status 204 }

  # operators
  get("/#{version}/operators") { json_response 200, 'operator_list.json' }
  get("/#{version}/operators/invalid_id") do
    json_response 404, 'resource_not_found.json'
  end
  get("/#{version}/operators/valid_id") { json_response 200, 'operator.json' }
  delete("/#{version}/operators/invalid_id") do
    json_response 404, 'resource_not_found.json'
  end
  delete("/#{version}/operators/valid_id") { status 204 }
  post("/#{version}/operators/password/change") do
    json_response 200, 'operator.json'
  end
  put("/#{version}/operators/invalid_id") do
    json_response 404, 'resource_not_found.json'
  end
  put("/#{version}/operators/valid_id") { json_response 200, 'operator.json' }
  put("/#{version}/operators/valid_id/assign") { status 204 }
  put("/#{version}/operators/invalid_id/assign") do
    json_response 404, 'resource_not_found.json'
  end
  post("/#{version}/operators/password/forgot") do
    json_response 200, 'operator_forgot_password.json'
  end
  post("/#{version}/operators/password/reset") do
    request.body.rewind
    request_payload = JSON.parse request.body.read
    if request_payload['params'] == 'valid'
      json_response 200, 'operator.json'
    else
      json_response 400, 'invalid_request_body.json'
    end
  end
  post("/#{version}/operators") do
    request.body.rewind
    request_payload = JSON.parse request.body.read
    if request_payload['params'] == 'valid'
      json_response 201, 'operator.json'
    else
      json_response 400, 'invalid_request_body.json'
    end
  end

  # session
  post("/#{version}/login") do
    request.body.rewind
    request_payload = JSON.parse request.body.read
    if request_payload['password'] == 'valid_password'
      json_response(200, 'user.json')
    else
      json_response(401, 'unauthorized.json')
    end
  end
  post("/#{version}/operators/login") { json_response 200, 'operator.json' }

  # password resets
  post("/#{version}/tenant/valid_user_id/password") do
    json_response 200, 'password_reset_token.json'
  end
  post("/#{version}/tenant/invalid_user_id/password") do
    json_response 404, 'resource_not_found.json'
  end
  put("/#{version}/tenant/valid_user_id/password") do
    request.body.rewind
    request_payload = JSON.parse request.body.read
    if request_payload['token'] == 'valid_token'
      json_response(200, 'user.json')
    else
      json_response(400, 'invalid_request_body.json')
    end
  end
  put("/#{version}/tenant/invalid_user_id/password") do
    json_response 404, 'resource_not_found.json'
  end

  # products
  get("/#{version}/products") { json_response 200, 'products.json' }

  # portfolios
  get("/#{version}/portfolios") { json_response 200, 'portfolios.json' }
  get("/#{version}/portfolios/valid_id") { json_response 200, 'portfolio.json' }
  get("/#{version}/portfolios/invalid_id") do
    json_response 404, 'resource_not_found.json'
  end
  post("/#{version}/portfolios") do
    request.body.rewind
    request_payload = JSON.parse request.body.read
    if request_payload['product'] == 'invalid'
      json_response(400, 'invalid_request_body.json')
    else
      json_response(200, 'portfolio.json')
    end
  end
  put("/#{version}/portfolios/valid_id") { json_response 200, 'portfolio.json' }
  put("/#{version}/portfolios/invalid_id") do
    json_response 404, 'resource_not_found.json'
  end
  delete("/#{version}/portfolios/valid_id") { status 204 }
  delete("/#{version}/portfolios/invalid_id") do
    json_response 404, 'resource_not_found.json'
  end

  # alert definitions
  get("/#{version}/portfolio/alerts/definitions") do
    json_response 200, 'alert_definitions.json'
  end
  get("/#{version}/portfolio/alerts/definitions/valid_id") do
    json_response 200, 'alert_definition.json'
  end
  get("/#{version}/portfolio/alerts/definitions/invalid_id") do
    json_response 404, 'resource_not_found.json'
  end

  # alert occurrences
  get("/#{version}/portfolio/alerts/occurrences") do
    json_response 200, 'alert_occurrences.json'
  end

  # portfolios alerts
  get("/#{version}/portfolios/valid_id/alerts") do
    json_response 200, 'portfolios_alerts.json'
  end
  get("/#{version}/portfolios/invalid_id/alerts") do
    json_response 404, 'resource_not_found.json'
  end
  put("/#{version}/portfolios/valid_id/alerts/valid_id") { status 204 }
  put("/#{version}/portfolios/invalid_id/alerts/invalid_id") do
    json_response 404, 'resource_not_found.json'
  end
  delete("/#{version}/portfolios/valid_id/alerts/valid_id") { status 204 }
  delete("/#{version}/portfolios/invalid_id/alerts/invalid_id") do
    json_response 404, 'resource_not_found.json'
  end

  # portfolios consumers
  get("/#{version}/portfolios/valid_id/consumers") do
    json_response 200, 'portfolios_consumers.json'
  end
  get("/#{version}/portfolios/invalid_id/consumers") do
    json_response 404, 'resource_not_found.json'
  end
  post("/#{version}/portfolios/valid_id/consumers") { status 204 }
  post("/#{version}/portfolios/invalid_id/consumers") do
    json_response 400, 'multiple_consumer_subscribe_error.json'
  end
  post("/#{version}/portfolios/valid_id/consumers/valid_id") { status 204 }
  post("/#{version}/portfolios/invalid_id/consumers/invalid_id") do
    json_response 400, 'single_consumer_subscribe_error.json'
  end
  delete("/#{version}/portfolios/valid_id/consumers/valid_id") { status 204 }
  delete("/#{version}/portfolios/invalid_id/consumers/invalid_id") do
    json_response 404, 'resource_not_found.json'
  end

  # portfolios available consumers
  get("/#{version}/portfolios/:id/consumers/available") do
    json_response 200, 'portfolios_available_consumers.json'
  end

  # consumers portfolios
  get("/#{version}/consumers/valid_id/portfolios") do
    json_response 200, 'portfolios.json'
  end
  get("/#{version}/consumers/invalid_id/portfolios") do
    json_response 404, 'resource_not_found.json'
  end

  # portfolio reports
  get("/#{version}/portfolio/reports") do
    json_response 200, 'portfolio_reports.json'
  end

  # relevance
  get("/#{version}/relevance/ruleset/names") do
    json_response 200, 'relevance_ruleset_names.json'
  end

  # errors
  get("/#{version}/client_error") { json_response 400, 'error.json' }
  get("/#{version}/server_error") { status 500 }
  get("/#{version}/proxy_error") { status 407 }

  # timeout
  get("/#{version}/orders/timeout") { status 419 }

  private

  def json_response(response_code, file_name)
    http_response :json, response_code, file_name
  end

  def png_response(file_name)
    http_response :png, 200, file_name
  end

  def pdf_response(file_name)
    http_response 'application/pdf', 200, file_name
  end

  def http_response(content_type, response_code, file_name)
    content_type content_type
    status response_code
    File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read
  end
end
