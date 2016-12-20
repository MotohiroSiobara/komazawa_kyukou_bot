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

  def push_message(text) # メッセージ送信
    User.all.each do |user|
      response = @client.push_message(user.user_id, message(text))
    end
    kiyari_push
  end

  def kiyari_push # キャリーに送信
    kiyari = User.find_by(user_id: "U04a42b4160452093315b013ae6d67f07")
    text = "あと#{kiyari.display_name}さん水曜日にファイナンス理論のプリント持ってきてくれると助かります。"
    @client.push_message(kiyari.user_id, message(text))
  end

  def test_push # テスト用のメッセージ送信
    text = "これはテストです"
    response = @client.push_message(MY_LINE_ID, message(text))
  end

  def register_friend(user_id, reply_token) # 友達登録
    unless User.exists?(user_id: user_id)
      get_profile(user_id)
      response = @client.reply_message(reply_token, message("登録が完了しました。毎朝9時に休講情報を配信します。"))
    else
      p "登録済み"
    end
  end

  def get_profile(user_id) # userの情報を取得
    response = @client.get_profile(user_id)
    case response
    when Net::HTTPSuccess then
      contact = JSON.parse(response.body)
      display_name = contact['displayName']
      picture = contact['pictureUrl']
      status = contact['statusMessage']
      User.create(user_id: user_id, display_name: display_name, picture_url: picture, status_message: status)
    else
      response = @client.reply_message(reply_token, message("登録に失敗しました。一度ブロックしてから再度友達追加をお願いします"))
    end
  end

  def message(text)
    message = {
      type: 'text',
      text: text,
    }
  end
end
