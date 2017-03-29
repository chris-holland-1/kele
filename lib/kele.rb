require 'rest_client'
require 'httparty'

class Kele
  include HTTParty

  def initialize(email, password)
    response = self.class.post("https://www.bloc.io/api/v1", header: {:content_type => 'application/json'}, body: {"email": email, "password": password})
    raise Error.new() if response.code != 200
    @auth_token = response["auth_token"]
  end
end
