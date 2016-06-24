require 'sinatra/base'

class FakeApi < Sinatra::Base
  # users
  get('/v1/users/:id') { json_response 200, 'user.json' }

  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read
  end
end
