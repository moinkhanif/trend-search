require 'nokogiri'
require 'rest-client'
require 'geocoder'
require 'os'
require 'cgi'
require 'easy_translate'
require 'dotenv/load'
require_relative 'change'
require_relative 'interface'

class Scraper
  include Change
  include Interface
  def initialize(country, country_name)
    @country = country
    @country_name = country_name
    @t = 5
  end

  def scrap
    url = "https://trends.google.com/trends/trendingsearches/daily/rss?geo=#{@country}"
    unparsed_page = RestClient.get(url)
    parsed_page = Nokogiri::XML(unparsed_page)
    items = parsed_page.xpath('//item')
    @news = items.xpath('//ht:news_item[1]/ht:news_item_title[1]')
    @news_url = items.xpath('//ht:news_item[1]/ht:news_item_url[1]')
  rescue StandardError
    false
  end

  def start
    scrap
    puts
    p "Today's Top #{@t} Trends in #{@country_name}" unless @news.empty?
    puts
    @t.times do |i|
      news_display(i)
    end
    news_menu
  end

  def num?(num)
    Integer(num)
  rescue StandardError
    false
  end
end
