require 'open-uri'
require 'nokogiri'

class StatsParser
  class << self
    def parse_data(link)
      # 'https://cod.tracker.gg/warzone/profile/:platform/:nickname/overview'
      html = open(link)
      doc = Nokogiri::HTML(html)
      arr = [doc.css('.main').first, doc.css('.giant-stats')]
      stats = []
      arr.map do |i|
        i.css('.numbers').each do |numbers|
          value = numbers.css('.value').text
          name = numbers.css('.name').text
          stats << "#{name}: #{value}"
        end
      end
      stats.join("\n")
    end
  end
end
