require_relative 'twitter_session'

class Status
  attr_accessor :user, :text

  def self.parse(json)
   JSON.parse(json).map do |hash|
     make_status(hash)
   end
  end

  def self.make_status(hash)
    Status.new(hash["user"]["screen_name"],
      hash["text"])
  end

  def initialize(author, message)
    @user = author
    @text = message
  end


end