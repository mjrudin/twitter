require 'json'
require_relative 'twitter_session'
require 'addressable/uri'


class User
  @@users = []
  def self.users
    @@users
  end

  def self.make_new(user_array)
    user_array.map do |user|
      User.new(user["screen_name"])
    end
  end

  def initialize(username)
    @username = username
    @@users << self
  end

  def followers
    json = TwitterSession.access_token.get(
     "https://api.twitter.com/1.1/followers/list.json").body
    grab_screen_names(json)
  end

  def followed_users
    json = TwitterSession.access_token.get(
     "https://api.twitter.com/1.1/friends/list.json").body
     grab_screen_names(json)
  end

  def timeline
    json = TwitterSession.access_token.get(
    "https://api.twitter.com/1.1/statuses/user_timeline.json").body
    Status.parse(json)
  end

  def grab_screen_names(json)
    users = JSON.parse(json)["users"]
    User.make_new(users)
    users.empty? ? [] : users.map do |user|
      user["screen_name"]
    end
  end
end

class EndUser < User

  @@current_user

  def self.set_user_name(user_name)
    @@current_user = EndUser.new(user_name)
  end

  def self.me
    @@current_user
  end

  def post_status(status_text)
    begin
      http = TwitterSession.access_token.post(format_status(status_text))
      raise "ERROR! #{http.to_s}" unless http.to_s.include?("HTTPOK")
    rescue Exception => e
      puts e.message
    end
  end

  def format_status(status_text)
    Addressable::URI.new(
      :scheme => "https",
      :host => "api.twitter.com",
      :path => "1.1/statuses/update.json",
      :query_values => {:status => status_text}).to_s
  end

  def direct_message(other_user, text)
    begin
      http = TwitterSession.access_token.post(format_message(other_user,text))
      raise "ERROR! #{http.to_s}" unless http.to_s.include?("HTTPOK")
    rescue Exception => e
      puts e.message
    end
  end

  def format_message(other_user, text)
    Addressable::URI.new(
      :scheme => "https",
      :host => "api.twitter.com",
      :path => "1.1/direct_messages/new.json",
      :query_values => {:screen_name => other_user,
                        :text => text}).to_s
  end
end
