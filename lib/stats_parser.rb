require 'open-uri'
require 'nokogiri'

class StatsParser
  def initialize(url)
    @url = url # 'https://cod.tracker.gg/warzone/profile/xbl/Sou1Jkeee/overview'
    html = open(url)

    doc = Nokogiri::HTML(html)
    @main = doc.css('.main').first
    @giant = doc.css('.giant-stats')
  end

  def get_stats
    stats = []
    @giant.css('.numbers').each do |numbers|
      value = numbers.css('.value').text
      name = numbers.css('.name').text
      stats << "#{name}: #{value}"
    end

    @main.css('.numbers').each do |numbers|
      value = numbers.css('.value').text
      name = numbers.css('.name').text
      stats << "#{name}: #{value}"
    end
    stats
  end
end
