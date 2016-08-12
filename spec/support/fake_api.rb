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

  # orders
  post('/v2/orders/valid_token') { json_response 200, 'order_token.json' }
  post('/v2/orders/invalid_token') { json_response 404, 'resource_not_found.json' }
  get('/v2/orders/:id') { json_response 200, 'resource.json' }
  get('/v2/list/orders/:page/:requested/:sort/:asc') { json_response 200, 'orders.json' }

  # institutions
  get('/v2/institutions/site/valid_site_id/form') { json_response 200, 'institution_login_form.json' }
  get('/v2/institutions/site/invalid_site_id/form') { json_response 400, 'invalid_institution_id.json' }
  post('/v2/institutions/site/valid_site_id/add') { json_response 200, 'institution_add.json' }
  post('/v2/institutions/site/invalid_site_id/add') { json_response 400, 'invalid_institution_id.json' }


  # users
  get('/v2/users/valid_public_id') { json_response 200, 'user.json' }
  get('/v2/users/invalid_public_id') { json_response 404, 'resource_not_found.json' }
  put('/v2/users/valid_public_id') { status 204 }
  put('/v2/users/valid_public_id/password') { json_response 200, 'user.json' }
  put('/v2/users/invalid_public_id/password') { json_response 404, 'resource_not_found.json' }

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

  # relevance
  get('/v2/relevance/ruleset/names') { json_response 200, 'relevance_ruleset_names.json' }

  # errors
  get('/v2/client_error') { json_response 400, 'error.json' }
  get('/v2/server_error') { status 500 }
  get('/v2/proxy_error') { status 407 }

  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read
  end
end
