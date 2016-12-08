require 'line/bot'
require 'open-uri'
require 'json'
require "nokogiri"

class NoLectures
  MY_LINE_ID = ENV['MY_LINE_ID']
  USAMINCHI_ID = ENV['USAMINCHI_LINE_ID']
  CHANNEL_SECRET = ENV['LINE_CHANNEL_SECRET']
  ACCESS_TOKEN = ENV['LINE_CHANNEL_ACCESS_TOKEN']

  # def initialize
  url = 'https://www.komazawa-u.ac.jp/~kyoumu/lesson/kyukou/WTKYUD.html'
  charset = nil
  html = open(url) do |f|
    charset = f.charset # 文字種別を取得
    f.read # htmlを読み込んで変数htmlに渡す
  end

  # htmlをパース(解析)してオブジェクトを生成
  doc = Nokogiri::HTML.parse(html, nil, charset)
  text = doc.css("table").text.to_s

  p CHANNEL_SECRET
  p ACCESS_TOKEN
  p MY_LINE_ID

  message = {
    type: 'text',
    text: text
  }
  client = Line::Bot::Client.new { |config|
      config.channel_secret = CHANNEL_SECRET
      config.channel_token = ACCESS_TOKEN
  }
  response = client.push_message(MY_LINE_ID, message)
  p response
end
