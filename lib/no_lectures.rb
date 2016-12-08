require 'line/bot'
require 'open-uri'
require 'json'
require "nokogiri"

class NoLectures
  MY_LINE_ID = ENV['MY_LINE_ID']
  USAMINCHI_ID = ENV['USAMINCHI_LINE_ID']
  CHANNEL_SECRET = ENV['LINE_CHANNEL_SECRET']
  ACCESS_TOKEN = ENV['LINE_CHANNEL_ACCESS_TOKEN']
  URL = "https://www.komazawa-u.ac.jp/~kyoumu/lesson/kyukou/WTKYUD.html"

  # def initialize
  url = 'https://www.komazawa-u.ac.jp/~kyoumu/lesson/kyukou/WTKYUD.html'
  # url = "http://qiita.com/mm36/items/9c446ab8e034ad898b15"
  charset = nil
  html = open(url) do |f|
    charset = f.charset # 文字種別を取得
    f.read # htmlを読み込んで変数htmlに渡す
  end

  # htmlをパース(解析)してオブジェクトを生成
  doc = Nokogiri::HTML.parse(html, nil, charset)
  p doc.css("table").text.to_s
  text = doc.css("table").text.to_s
  # res = open(url)
  # result = ActiveSupport::JSON.decode res.read
  # p result.css('body > center > table:nth-child(7) > tbody > tr > td > font')
  #   @url = open(url).read
  #   doc = Nokogiri::HTML.parse(@url)
  #   json = doc
  #   @response = JSON.parse(json)
  #   puts response
  # end
  # # 休講情報を取得
  # charset = nil
  # html = open(URL) do |f|
  #   charset = f.charset # 文字種別を取得
  #   f.read # htmlを読み込んで変数htmlに渡す
  # end
  # Capybara.register_driver :poltergeist do |app|
  #   Capybara::Poltergeist::Driver.new(app, {:js_errors => false, :timeout => 1000 })
  # end
  # session = Capybara::Session.new(:poltergeist)
  # session.visit "https://www.komazawa-u.ac.jp/~kyoumu/lesson/kyukou/KKE0601.html"
  # sleep(1)
  # session.find("body > table:nth-child(2) > tbody > tr > td > div > table > tbody > tr > td > table > tbody > tr:nth-child(2) > td > center > a > b > font").click
  # # puts session.charset
  # page = Nokogiri::HTML.parse(html, nil, charset)
  # res = open("https://www.komazawa-u.ac.jp/~kyoumu/lesson/kyukou/WTKYUD.html")
  # result = ActiveSupport::JSON.decode res.read
  # p result

  # html = open('https://www.komazawa-u.ac.jp/~kyoumu/lesson/kyukou/WTKYUD.html').read
  # json = JSON.parser.new(html)
  # #parse()メソッドでハッシュ生成
  # hash =  json.parse()
  # p hash
  # text = []
  # page.css('body > center > table:nth-child(7) > tbody > tr > td > font').each do |data|
  #   text << data.inner_html
  # end
  # text = text.join("\n")
  # p text
  # # text = "こんばんは"
  # # session.save_screenshot "kyoukou.png"
  # text = "今日は"
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
