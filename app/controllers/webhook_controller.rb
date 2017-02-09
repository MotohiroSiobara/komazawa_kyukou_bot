require 'line/bot'

class WebhookController < ApplicationController
   protect_from_forgery with: :null_session # CSRF対策無効化

  CHANNEL_SECRET = ENV['LINE_CHANNEL_SECRET']

  def callback
    unless is_validate_signature
      render :nothing => true, status: 470
    end
    params = JSON.parse(request.body.read)
    user_id = params["events"][0]["source"]["userId"]
    event_type = params["events"][0]["type"]
    reply_token = params["events"][0]["replyToken"]
    if event_type == "follow"
      LineClient.new.register_friend(user_id, reply_token)
    elsif event_type == "unfollow"
      User.find_by(user_id: user_id).destroy
    end
  end

  private

  def is_validate_signature
    signature = request.headers["X-LINE-ChannelSignature"]
    http_request_body = request.raw_post
    hash = OpenSSL::HMAC::digest(OpenSSL::Digest::SHA256.new, CHANNEL_SECRET, http_request_body)
    signature_answer = Base64.strict_encode64(hash)
    signature == signature_answer
  end
end
