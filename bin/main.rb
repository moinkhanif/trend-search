require 'nokogiri'
require 'rest-client'
require 'geocoder'
require 'os'
require 'cgi'

def scraper
  country = 'US'
  t = 5
  url = "https://trends.google.com/trends/trendingsearches/daily/rss?geo=#{country}"
  unparsed_page = RestClient.get(url)
  parsed_page = Nokogiri::XML(unparsed_page)
  items = parsed_page.xpath('//item')
  news = items.xpath('//ht:news_item[1]/ht:news_item_title[1]')
  news_url = items.xpath('//ht:news_item[1]/ht:news_item_url[1]')
  puts
  p "Top #{t} Trends in #{country}"
  puts
  t.times do |i|
    p "#{i + 1} #{CGI.unescapeHTML(news[i].text)}"
  end
  puts
  p "To access any news, please enter the number displayed beside the title OR press 'm' for menu"
  user_in = gets.chomp
  user_num =
    begin
      Integer(user_in)
    rescue StandardError
      false
    end
  system(OS.open_file_command, news_url[user_in.to_i - 1].text) if user_num
end
scraper
