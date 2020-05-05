module Change
  def country_change
    p 'Please enter the country name'
    new_country = gets.chomp
    if new_country.downcase != Geocoder.search(new_country).first.country.downcase
      p "Did you mean #{Geocoder.search(new_country).first.country}? (y/n)"
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
    initialize('US', 'United States')
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

  def country_change_confirmed(new_country)
    @country = Geocoder.search(new_country).first.country_code.upcase
    @country_name = Geocoder.search(new_country).first.country
    puts
    p "Country changed to #{@country_name}!"
    puts
    menu
  end
end
