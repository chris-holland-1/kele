require 'httparty'
require 'json'
require_relative 'kele/roadmap'

class Kele
  include HTTParty
  include Roadmap

  def initialize(email, password)
    response = self.class.post("https://www.bloc.io/api/v1/sessions", body: {"email": email, "password": password})
    raise "Invalid email or password" if response.code != 200
    @auth_token = response["auth_token"]
    #@api_url = 'https://www.bloc.io/api/v1'
    #@auth_token = self.class.post(@api_url + '/sessions', body: { username: username, password: password })["auth_token"]
    #raise StandardError.new('Invalid credentials') unless @auth_token
  end

  def get_me
    response = self.class.get("https://www.bloc.io/api/v1/users/me", headers: { "authorization" => @auth_token })
    @current_user = JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)
    response = self.class.get("https://www.bloc.io/api/v1/mentors/#{mentor_id}/student_availability", headers: { "authorization" => @auth_token })
    @mentor_availability = JSON.parse(response.body)
  end

  def get_messages
    response = self.class.get("https://www.bloc.io/api/v1/message_threads", headers: { "authorization" => @auth_token })
    @messages = JSON.parse(response.body)
  end

  def create_message(sender, recipient_id, token, subject, stripped_text)
    response = self.class.post("https://www.bloc.io/api/v1/messages", values: {"sender": sender, "recipient_id": recipient_id, "token": token, "subject": subject, "stripped_text": stripped-text}, headers: { "authorization" => @auth_token })
    @create_message = JSON.parse(response.body)
  end

  def create_submission(assignment_branch, assignment_commit_link, checkpoint_id, comment)
    #enrollment_id included in user information
    response = self.class.post("https://www.bloc.io/api/v1/checkpoint_submissions", values: {"assignment_branch": assignment_branch, "assignment_commit_link": assignment_commit_link, "checkpoint_id": checkpoint_id, "comment": comment}, headers: { "authorization" => @auth_token })
    @submission = JSON.parse(response.body)
  end
end
