# frozen_string_literal: true
require 'sinatra/base'

# the FakeApi class is used to mock API requests while testing.
class FakeApi < Sinatra::Base
  # resource
  post('/v2/resources') { json_response 201, 'resource.json' }
  get('/v2/resources/:id') { json_response 200, 'resource.json' }

  # orders
  post('/v2/orders/invalid_token') { json_response 404, 'order_token_invalid.json' }
  post('/v2/orders/valid_token') { json_response 200, 'order_token.json' }
  get('/v2/orders/:id') { json_response 200, 'resource.json' }

  # users
  get('/users/:id') { json_response 200, 'user.json' }

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
