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
    else event_type == "unfollow"
      User.find_by(user_id: user_id).destroy
    end
  end

  private
  # LINEからのアクセスか確認
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

curl "https://api.line.me/v2/bot/profile/U19c32cb98a75d8e25fd2b90b3f0c7d0f"\
-H "X-Line-ChannelSecret: d9ac97da586041af82ef133a47504f05"\
-H "Authorization: Bearer l6vsvu2NvtKO2bdTemTeYAyR5X2XzO10aHnmRymSpNYQ4ndq45yt135NQSX859IR9kw703d2fA0f4JPAJVmFBl+p0s/1LxQHq/iUTrsIwCA3/fjap+5P5+X8YlNxrfcEb6ND90Xetp2BvCAgcRfWtwdB04t89/1O/w1cDnyilFU="
