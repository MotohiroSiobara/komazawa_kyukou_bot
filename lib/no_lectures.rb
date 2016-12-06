require 'line/bot'
require 'capybara/poltergeist'
require 'nokogiri'
require 'phantomjs'

class NoLectures
  MY_LINE_ID = ENV['MY_LINE_ID']
  USAMINCHI_ID = ENV['USAMINCHI_LINE_ID']
  CHANNEL_SECRET = ENV['LINE_CHANNEL_SECRET']
  ACCESS_TOKEN = ENV['LINE_CHANNEL_ACCESS_TOKEN']
  # # 休講情報を取得
  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(app, {:js_errors => false, :timeout => 1000 })
  end
  session = Capybara::Session.new(:poltergeist)
  session.visit "https://www.komazawa-u.ac.jp/~kyoumu/lesson/kyukou/KKE0601.html"
  session.find("body > table:nth-child(2) > tbody > tr > td > div > table > tbody > tr > td > table > tbody > tr:nth-child(2) > td > center > a > b > font").click
  # puts session.charset
  page = Nokogiri::HTML.parse(session.html, nil, 'utf-8')
  text = []
  page.css('body > center > table:nth-child(7) > tbody > tr > td > font').each do |data|
    text << data.inner_html
  end
  text = text.join("\n")

  session.save_screenshot "kyoukou.png"
  message = {
    type: 'text',
    text: text
  }
  client = Line::Bot::Client.new { |config|
      config.channel_secret = "d9ac97da586041af82ef133a47504f05"
      config.channel_token = "l6vsvu2NvtKO2bdTemTeYAyR5X2XzO10aHnmRymSpNYQ4ndq45yt135NQSX859IR9kw703d2fA0f4JPAJVmFBl+p0s/1LxQHq/iUTrsIwCA3/fjap+5P5+X8YlNxrfcEb6ND90Xetp2BvCAgcRfWtwdB04t89/1O/w1cDnyilFU="
  }
  response = client.push_message(MY_LINE_ID, message)
  puts response
end
