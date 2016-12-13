require 'line/bot'

class LineClient
  MY_LINE_ID = ENV['MY_LINE_ID']
  USAMINCHI_ID = ENV['USAMINCHI_LINE_ID']
  CHANNEL_SECRET = ENV['LINE_CHANNEL_SECRET']
  ACCESS_TOKEN = ENV['LINE_CHANNEL_ACCESS_TOKEN']

  def initialize
    @client = Line::Bot::Client.new { |config|
        config.channel_secret = CHANNEL_SECRET
        config.channel_token = ACCESS_TOKEN
    }
  end

  def push_message(text)
    message = {
      type: 'text',
      text: text
    }
    User.all.each do |user|
      response = @client.push_message(user.user_id, message)
    end
  end
end
