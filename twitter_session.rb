require 'oauth'
require 'launchy'

class TwitterSession
  CONSUMER_KEY
  CONSUMER_SECRET

  CONSUMER = OAuth::Consumer.new(
  CONSUMER_KEY, CONSUMER_SECRET, :site => "https://twitter.com")

  def self.access_token
    @@access_token unless @@access_token.nil?
    request_token = CONSUMER.get_request_token
    authorize_url = request_token.authorize_url
    puts "Taking you to #{authorize_url} to authorize."
    Launchy.open(authorize_url)

  end
end