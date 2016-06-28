require 'sinatra/base'

class FakeApi < Sinatra::Base
  # users
  get('/users/:id') { json_response 200, 'user.json' }

  # relevance
  get('/v2/relevance/ruleset/names') { json_response 200, 'relevance_ruleset_names.json' }

  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read
  end
end
