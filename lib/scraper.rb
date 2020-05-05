require 'nokogiri'
require 'rest-client'
require 'geocoder'
require 'os'
require 'cgi'
require 'easy_translate'
require 'dotenv/load'

class Scraper
  def initialize
    @country = 'US'
    @country_name = 'United States'
    @t = 5
  end

  def menu
    puts
    p 'Please choose your option:'
    p "1. Show Trends from  #{@country_name}"
    p '2. Show Trends from a different country'
    p '3. Change Number of Trends to Show'
    p '4. Reset country and number of trend'
    p "5 or 'q' to Quit"
    user_i_m = gets.chomp
    if num?(user_i_m)
      case user_i_m
      when '1'
        begin
          start
        rescue StandardError
          p 'This country is unavailable with google trends.'
          initialize    
          menu
        end
      when '2'
        p 'Please enter the country name'
        new_country = gets.chomp
        @country = Geocoder.search(new_country).first.country_code.upcase
        @country_name = Geocoder.search(new_country).first.country
        puts
        p "Country changed to #{@country_name}!"
        puts
        menu
      when '3'
        p 'Please enter the number of stories you want to view'
        new_t = gets.chomp
        if num?(new_t) && new_t.to_i <= @news.size
          @t = new_t.to_i
          start
        else
          menu
        end
      when '4'
        initialize  
        p "Country has been reset to #{@country_name} and number of trends to #{@t}"
        puts
        menu
      when '5', 'q'
        p 'Thank you for using Trend Search! Good day!'
      else
        p 'invalid Input! Please try again'
        menu
      end
    elsif user_i_m.downcase == 'q'
      p 'Thank you for using Trend Search! Good day!'
    else
      p 'invalid Input! Please try again'
      menu
    end
  end

  def num?(num)
    Integer(num)
  rescue StandardError
    false
  end

  def start
    url = "https://trends.google.com/trends/trendingsearches/daily/rss?geo=#{@country}"
    unparsed_page = RestClient.get(url)
    parsed_page = Nokogiri::XML(unparsed_page)
    items = parsed_page.xpath('//item')
    @news = items.xpath('//ht:news_item[1]/ht:news_item_title[1]')
    news_url = items.xpath('//ht:news_item[1]/ht:news_item_url[1]')
    puts
    p "Today's Top #{@t} Trends in #{@country_name}"
    puts
    @t.times do |i|
      p "#{i + 1}. #{CGI.unescapeHTML(@news[i].text)}".delete('\\"')
      begin
        EasyTranslate.api_key = ENV['TRANSLATE_KEY']
        if EasyTranslate.detect(CGI.unescapeHTML(@news[i].text)) != 'en'

          p "^Translation: #{EasyTranslate.translate(CGI.unescapeHTML(@news[i].text), to: 'en')}".delete('\\"')
          puts
        end
      rescue StandardError
        puts
      end
    end
    puts
    p 'To access any news, please enter the number displayed beside the title'
    p "OR press 'm' for menu or 'q' to quit"
    user_in = gets.chomp
    user_num = num?(user_in)

    if user_num
      system(OS.open_file_command, news_url[user_in.to_i - 1].text)
      puts
      p 'Link opened in the browser window!'
      puts
      menu
    else
      case user_in.downcase
      when 'q'
        p 'Thank you for using Trend Search! Good day!'
      when 'm'
        menu
      else
        puts
        p 'Invalid Input, redirecting to Menu'
        menu
      end
    end
  end
end