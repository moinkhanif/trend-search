require 'nokogiri'
require 'rest-client'
require 'geocoder'
require 'os'
require 'cgi'

def menu
  p 'Please choose your option:'
  p '1. Change Number of Trends to Show'
  p '2. Show Trends from a different country'
  p '3. Show stories again'
  user_i_m = gets.chomp
  if num?(user_i_m)
    case user_i_m.to_i
    when 1
      p 'Please enter the number of stories you want to view'
      new_t = gets.chomp
      if num?(new_t) && new_t.to_i <= @news.size
        @t = new_t 
        start
      else
        menu
      end
    when 2
      p 'Please enter the country name'
      new_country = gets.chomp
      @country = Geocoder.search(new_country).first.country_code.upcase
      p "country changed to #{@country}!"
      menu
    when 3
      start
    end
  else
    p 'kayum'
  end
end

def num?(i)
  begin
    Integer(i)
  rescue StandardError
    false
  end
end
def ini
  @country = 'US'
  @t = 5
end
def start
  url = "https://trends.google.com/trends/trendingsearches/daily/rss?geo=#{@country}"
  unparsed_page = RestClient.get(url)
  parsed_page = Nokogiri::XML(unparsed_page)
  items = parsed_page.xpath('//item')
  @news = items.xpath('//ht:news_item[1]/ht:news_item_title[1]')
  news_url = items.xpath('//ht:news_item[1]/ht:news_item_url[1]')
  puts
  p "Top #{@t} Trends in #{@country}"
  puts
  @t.times do |i|
    p "#{i + 1} #{CGI.unescapeHTML(@news[i].text)}"
  end
  puts
  p "To access any news, please enter the number displayed beside the title" 
  p "OR press 'm' for menu or 'q' to quit"
  user_in = gets.chomp
  user_num = num?(user_in)
    
  if user_num
    system(OS.open_file_command, news_url[user_in.to_i - 1].text)
  else
    case user_in
    when 'q'
      p 'Thank you for using Trend Search! Good day!'
    when 'm'
      menu
    else
      p 'k'
    end
  end
end
ini
start
