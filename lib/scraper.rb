require 'line/bot'

message = {
  type: 'text',
  text: 'hello'
}
client = Line::Bot::Client.new { |config|
    config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
    config.channel_token = ENV["LINE_CHANNEL_ACCESS_TOKEN"]
}
response = client.push_message("U5f76a050a6809546f1dcae891122b9bd", message)
p response
