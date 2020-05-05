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

  def country_change_confirmed(new_country)
    @country = Geocoder.search(new_country).first.country_code.upcase
    @country_name = Geocoder.search(new_country).first.country
    puts
    p "Country changed to #{@country_name}!"
    puts
    menu
  end

  def country_change
    p 'Please enter the country name'
    new_country = gets.chomp
    if new_country.downcase != Geocoder.search(new_country).first.country.downcase
      p "Did you mean #{Geocoder.search(new_country).first.country}?(y/n)"
      c_user_i = gets.chomp
      if c_user_i.downcase == 'y'
        country_change_confirmed(new_country)
      else
        p "We could'nt identify the country, please try again!"
        p 'Please note, even if you enter city name, we can only search using country name!'
        country_change
      end
    else
      country_change_confirmed(new_country)
    end
  rescue StandardError
    p 'Unable to change country! Resetting values...'
    initialize
    menu
  end

  def t_changer
    p 'Please enter the number of stories you want to view'
    new_t = gets.chomp
    if num?(new_t) and new_t.to_i <= @news.size
      @t = new_t.to_i
      start
    else
      menu
    end
  end

  def menu_controller(_usr_i_m)
    case user_i_m
    when '1'
      start
    when '2'
      country_change
    when '3'
      t_changer
    when '4'
      initialize
      puts
      p "Country has been reset to #{@country_name} and number of trends to #{@t}"
      menu
    when '5', 'q'
      p 'Thank you for using Trend Search! Good day!'
    else
      puts
      p 'invalid Input! Please try again'
      menu
    end
  end

  def menu
    puts
    menu_options = [
      "1. Show Daily Trends from  #{@country_name}",
      '2. Show Trends from a different country',
      '3. Change Number of Trends to Show',
      '4. Reset country and number of trend',
      "5 or 'q' to Quit"
    ]
    p 'Please choose your option:'
    menu_options.each { |op| p op }
    user_i_m = gets.chomp
    menu_controller(user_i_m)
  end

  def num?(num)
    Integer(num)
  rescue StandardError
    false
  end

  def scrap
    url = "https://trends.google.com/trends/trendingsearches/daily/rss?geo=#{@country}"
    unparsed_page = RestClient.get(url)
    parsed_page = Nokogiri::XML(unparsed_page)
    items = parsed_page.xpath('//item')
    @news = items.xpath('//ht:news_item[1]/ht:news_item_title[1]')
    @news_url = items.xpath('//ht:news_item[1]/ht:news_item_url[1]')
  end

  def news_menu
    puts
    p 'To access any news, please enter the number displayed beside the title'
    p "OR press 'm' for menu or 'q' to quit"
    user_in = gets.chomp
    user_num = num?(user_in)

    if user_num and user_num <= @t
      system(OS.open_file_command, @news_url[user_in.to_i - 1].text)
      puts
      p 'Link opened in the browser window!'
      menu
    else
      case user_in.downcase
      when 'q'
        p 'Thank you for using Trend Search! Good day!'
      when 'm'
        menu
      else
        puts
        p 'Invalid Input, please try again!'
        news_menu
      end
    end
  end

  def news_display(num)
    p "#{num + 1}. #{CGI.unescapeHTML(@news[num].text)}".delete('\\"')
    begin
      EasyTranslate.api_key = ENV['TRANSLATE_KEY']
      if EasyTranslate.detect(CGI.unescapeHTML(@news[num].text)) != 'en'
        p "^Translation: #{EasyTranslate.translate(CGI.unescapeHTML(@news[num].text), to: 'en')}".delete('\\"')
        puts
      end
    rescue StandardError
      puts
    end
  end

  def start
    scrap
    puts
    p "Today's Top #{@t} Trends in #{@country_name}"
    puts
    @t.times do |i|
      news_display(i)
    end
    news_menu
  rescue StandardError
    puts
    p 'This country is unavailable with google trends.'
    initialize
    p "Country reset back to #{@country_name}"
    menu
  end
end
