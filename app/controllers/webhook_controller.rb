require 'line/bot'

class WebhookController < ApplicationController
   protect_from_forgery with: :null_session # CSRF対策無効化

  CHANNEL_ID = ENV['LINE_CHANNEL_ID']
  CHANNEL_SECRET = ENV['LINE_CHANNEL_SECRET']
  OUTBOUND_PROXY = ENV['LINE_OUTBOUND_PROXY']
  ACCESS_TOKEN = ENV['LINE_CHANNEL_TOKEN']

  def callback
    unless is_validate_signature
      render :nothing => true, status: 470
    end
    params = JSON.parse(request.body.read)
    result = params["result"]
    text_message = params["events"][0]["message"]["text"]
    user_id = params["events"][0]["source"]["userId"]
    reply_token = params["events"][0]["replyToken"]
    User.create(user_id: user_id) unless User.exists?(user_id: user_id)
    # message = {
    #   type: 'text',
    #   text: text_message
    # }
    # logger.info(user_id)
    # logger.info(reply_token)
    # client = Line::Bot::Client.new { |config|
    #     config.channel_secret = CHANNEL_SECRET
    #     config.channel_token = ACCESS_TOKEN
    # }
    # response = client.reply_message(reply_token, message)
    # logger.info(response)
  end

  private
  # LINEからのアクセスか確認.
  # 認証に成功すればtrueを返す。
  # ref) https://developers.line.me/bot-api/getting-started-with-bot-api-trial#signature_validation
  def is_validate_signature
    signature = request.headers["X-LINE-ChannelSignature"]
    http_request_body = request.raw_post
    hash = OpenSSL::HMAC::digest(OpenSSL::Digest::SHA256.new, CHANNEL_SECRET, http_request_body)
    signature_answer = Base64.strict_encode64(hash)
    signature == signature_answer
  end
end
