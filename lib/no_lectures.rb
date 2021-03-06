require 'open-uri'
require 'json'
require "nokogiri"

class NoLectures

  def initialize
    url = 'https://www.komazawa-u.ac.jp/~kyoumu/lesson/kyukou/WTKYUD.html'
    charset = nil
    html = open(url) do |f|
      charset = f.charset
      f.read
    end
    scraper(html, charset)
  end

  def scraper(html, charset)
    doc = Nokogiri::HTML.parse(html, nil, charset)
    text = doc.css("table").text.to_s
    today = (Time.now + 9.hours).strftime("%Y/%m/%d")
    LineClient.new.push_message(text) if text.include?(today)
  end
end
