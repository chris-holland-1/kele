require 'httparty'
require 'json'

class Kele
  include HTTParty

  def initialize(email, password)
    #response = self.class.post("https://www.bloc.io/api/v1/sessions", body: {"email": email, "password": password})
    #raise "Invalid email or password" if response.code != 200
    #@auth_token = response["auth_token"]
    @api_url = 'https://www.bloc.io/api/v1'
    @auth_token = self.class.post(@api_url + '/sessions', body: { email: username, password: password })["auth_token"]
    raise StandardError.new('Invalid credentials') unless @auth_token
  end

  def get_me
    response = self.class.get("https://www.bloc.io/api/v1/users/me", headers: { "authorization" => @auth_token })
    @current_user = JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)
    response = self.class.get("https://www.bloc.io/api/v1/mentors/#{mentor_id}/student_availability", headers: { "authorization" => @auth_token })
    @mentor_availability = JSON.parse(response.body)
  end
end
