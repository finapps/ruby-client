# frozen_string_literal: true
require 'sinatra/base'

# the FakeApi class is used to mock API requests while testing.
class FakeApi < Sinatra::Base
  # resource
  post('/v2/resources') { json_response 201, 'resource.json' }
  get('/v2/resources/:id') { json_response 200, 'resource.json' }
  get('/v2/resources') { json_response 200, 'resources.json' }
  put('/v2/resources') { json_response 201, 'resource.json' }
  delete('/v2/resources/:id') { status 202 }

  # version
  get('/v2/version') { 'Version => 2.1.29-.20161208.172810' }

  # orders
  post('/v2/orders/valid_token') { json_response 200, 'order_token.json' }
  post('/v2/orders/invalid_token') { json_response 404, 'resource_not_found.json' }
  get('/v2/orders/valid_id') { json_response 200, 'order.json' }
  get('/v2/orders') { json_response 200, 'orders.json' }
  get('/v2/orders/valid_id/report.:format') { json_response 200, 'order_report.json' }
  get('/v2/orders/invalid_id/report.:format') { json_response 404, 'resource_not_found.json' }
  get('/v2/orders/valid_id/status') { json_response 200, 'order_status.json' }
  get('/v2/orders/invalid_id/status') { json_response 404, 'resource_not_found.json' }
  put('/v2/orders/invalid_id') { json_response 404, 'resource_not_found.json' }
  put('/v2/orders/valid_id') do
    request.body.rewind
    request_payload = JSON.parse request.body.read
    if request_payload['accounts'] == 'valid_account'
      status 204
    else
      json_response 400, 'invalid_request_body.json'
    end
  end
  post('/v2/orders') do
    request.body.rewind
    request_payload = JSON.parse request.body.read
    if %w(applicant institutions product).all? {|s| request_payload.key? s }
      json_response 200, 'order_token.json'
    else
      json_response 400, 'invalid_request_body.json'
    end
  end

  # institutions
  get('/v2/institutions/site/valid_site_id/form') { json_response 200, 'institution_login_form.json' }
  get('/v2/institutions/site/invalid_site_id/form') { json_response 400, 'invalid_institution_id.json' }
  post('/v2/institutions/site/valid_site_id/add') { json_response 200, 'institution_add.json' }
  get('/v2/institutions/search/:search_term') { json_response 200, 'institutions_search_list.json' }
  get('/v2/institutions/routing/:routing_number') { json_response 200, 'institutions_routing_number.json' }

  # user institutions
  get('/v2/institutions/consumer/valid_id/status') { json_response 200, 'user_institution_status.json' }
  get('/v2/institutions/consumer/invalid_id/status') { json_response 400, 'invalid_user_institution_id.json' }
  get('/v2/institutions/consumer') { json_response 200, 'user_institutions_list.json' }
  get('/v2/institutions/consumer/valid_id') { json_response 200, 'user_institutions_show.json' }
  get('/v2/institutions/consumer/invalid_id') { json_response 400, 'invalid_user_institution_id.json' }
  put('/v2/institutions/consumer/refresh') { json_response 200, 'user_institutions_refresh_all.json' }
  put('/v2/institutions/consumer/valid_id/credentials') { json_response 200, 'institution_add.json' }
  put('/v2/institutions/consumer/invalid_id/credentials') { json_response 400, 'invalid_user_institution_id.json' }
  put('/v2/institutions/consumer/valid_id/mfa') { json_response 200, 'institution_add.json' }
  put('/v2/institutions/consumer/invalid_id/mfa') { json_response 400, 'invalid_user_institution_id.json' }
  delete('/v2/institutions/consumer/valid_id') { status 204 }
  delete('/v2/institutions/consumer/invalid_id') { json_response 400, 'invalid_user_institution_id.json' }
  get('/v2/institutions/consumer/valid_id/form') { json_response 200, 'institution_login_form.json' }
  get('/v2/institutions/consumer/invalid_id/form') { json_response 400, 'invalid_institution_id.json' }
  put('/v2/institutions/refresh') { json_response 200, 'user_institution_refresh.json' }

  # consumers
  get('/v2/consumers/valid_public_id') { json_response 200, 'user.json' }
  get('/v2/consumers/invalid_public_id') { json_response 404, 'resource_not_found.json' }
  put('/v2/consumers/valid_public_id') { status 204 }
  put('/v2/consumers/invalid_public_id') { json_response 400, 'invalid_user_id.json' }
  put('/v2/consumers/valid_public_id/password') { json_response 200, 'user.json' }
  put('/v2/consumers/invalid_public_id/password') { json_response 404, 'resource_not_found.json' }
  delete('/v2/consumers/valid_public_id') { status 204 }
  delete('/v2/consumers/invalid_public_id') { json_response 404, 'resource_not_found.json' }

  # operators
  get('/v2/operators') { json_response 200, 'operator_list.json' }
  get('/v2/operators/invalid_id') { json_response 404, 'resource_not_found.json' }
  get('/v2/operators/valid_id') { json_response 200, 'operator.json' }
  delete('/v2/operators/invalid_id') { json_response 404, 'resource_not_found.json' }
  delete('/v2/operators/valid_id') { status 204 }
  post('/v2/operators/password/change') { json_response 200, 'operator.json' }
  put('/v2/operators/invalid_id') { json_response 404, 'resource_not_found.json' }
  put('/v2/operators/valid_id') { json_response 200, 'operator.json' }
  post('/v2/operators/password/forgot') { json_response 200, 'operator_forgot_password.json' }
  post('/v2/operators/password/reset')  do
    request.body.rewind
    request_payload = JSON.parse request.body.read
    if request_payload['params'] == 'valid'
      json_response 200, 'operator.json'
    else
      json_response 400, 'invalid_request_body.json'
    end
  end
  post('/v2/operators') do
    request.body.rewind
    request_payload = JSON.parse request.body.read
    if request_payload['params'] == 'valid'
      json_response 201, 'operator.json'
    else
      json_response 400, 'invalid_request_body.json'
    end
  end

  # session
  post('/v2/login') do
    request.body.rewind
    request_payload = JSON.parse request.body.read
    if request_payload['password'] == 'valid_password'
      json_response(200, 'user.json')
    else
      json_response(401, 'unauthorized.json')
    end
  end
  post('/v2/operators/login') { json_response 200, 'operator.json' }

  # password resets
  post('/v2/tenant/valid_user_id/password') { json_response 200, 'password_reset_token.json' }
  post('/v2/tenant/invalid_user_id/password') { json_response 404, 'resource_not_found.json' }
  put('/v2/tenant/valid_user_id/password') do
    request.body.rewind
    request_payload = JSON.parse request.body.read
    if request_payload['token'] == 'valid_token'
      json_response(200, 'user.json')
    else
      json_response(400, 'invalid_request_body.json')
    end
  end
  put('/v2/tenant/invalid_user_id/password') { json_response 404, 'resource_not_found.json' }

  # relevance
  get('/v2/relevance/ruleset/names') { json_response 200, 'relevance_ruleset_names.json' }

  # errors
  get('/v2/client_error') { json_response 400, 'error.json' }
  get('/v2/server_error') { status 500 }
  get('/v2/proxy_error') { status 407 }

  # timeout
  get('/v2/orders/timeout') { status 419 }

  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read
  end
end
