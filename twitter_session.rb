require 'oauth'
require 'launchy'
require_relative 'consumer'
require_relative 'status'
require_relative 'user'

class TwitterSession

  @@access_token = nil

  CONSUMER = OAuth::Consumer.new(
  Consumer::CONSUMER_KEY, Consumer::CONSUMER_SECRET,
  :site => "https://twitter.com")

  def self.access_token
    return @@access_token unless @@access_token.nil?

    begin
      request_token = CONSUMER.get_request_token
      authorize_url = request_token.authorize_url

      puts "Taking you to #{authorize_url} to authorize."
      sleep 1
      Launchy.open(authorize_url)
      puts "Type the PIN now:"
      oauth_verifier = gets.chomp.to_i
      @@access_token = request_token.get_access_token(
            :oauth_verifier => oauth_verifier)
      return
    rescue Exception => e
      puts e.message
      puts "Probably Twitter's fault, just trying again."
      sleep 1
      retry
    end
  end
end