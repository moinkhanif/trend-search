module Interface
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

  def menu_controller(usr_i_m)
    case usr_i_m
    when '1'
      start
    when '2'
      country_change
    when '3'
      t_changer
    when '4'
      initialize('US', 'United States')
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
    EasyTranslate.api_key = ENV['TRANSLATE_KEY']
    if EasyTranslate.detect(CGI.unescapeHTML(@news[num].text)) != 'en'
      p "^Translation: #{EasyTranslate.translate(CGI.unescapeHTML(@news[num].text), to: 'en')}".delete('\\"')
      puts
    end
  rescue StandardError
    puts
    false
  end
end
