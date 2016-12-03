class WebhookController < ApplicationController
   protect_from_forgery with: :null_session # CSRF対策無効化

  CHANNEL_ID = ENV['LINE_CHANNEL_ID']
  CHANNEL_SECRET = ENV['LINE_CHANNEL_SECRET']
  CHANNEL_MID = ENV['LINE_CHANNEL_MID']
  OUTBOUND_PROXY = ENV['LINE_OUTBOUND_PROXY']
  ACCESS_TOKEN = ENV['LINE_CHANNEL_TOKEN']

  def callback
    unless is_validate_signature
      render :nothing => true, status: 470
    end
    params = JSON.parse(request.body.read)
    # logger.info(params)
    # logger.info(params["result"])
    result = params["result"]
    # logger.info({from_line: result})
    # logger.info(params["events"][0]["message"]["text"])
    text_message = params["events"][0]["message"]["text"]
    # logger.info(params["events"][0]["source"]["userId"])
    from_mid = params["events"][0]["source"]["userId"]
    message = {
      type: 'text',
      text: 'hello'
    }
    client = Line::Bot::Client.new { |config|
        config.channel_secret = CHANNEL_SECRET
        config.channel_token = ACCESS_TOKEN
    }
    response = client.reply_message("e3432f1bb50340f99f1f893f818797ab", message)
    logger.info(response)

    client = LineClient.new(CHANNEL_ID, CHANNEL_SECRET, CHANNEL_MID, OUTBOUND_PROXY)
    res = client.send([from_mid], text_message)

    if res.status == 200
      logger.info({success: res})
    else
      logger.info({fail: res})
    end
    render :nothing => true, status: :ok, and return
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
