require 'open-uri'
require 'json'
require "nokogiri"

class NoLectures

  def initialize
    url = 'https://www.komazawa-u.ac.jp/~kyoumu/lesson/kyukou/WTKYUD.html'
    charset = nil
    html = open(url) do |f|
      charset = f.charset # 文字種別を取得
      f.read # htmlを読み込んで変数htmlに渡す
    end
    scraper(html, charset)
  end

  def scraper(html, charset)
    doc = Nokogiri::HTML.parse(html, nil, charset)
    text = doc.css("table").text.to_s
    LineClient.new.push_message(text)
  end
end
