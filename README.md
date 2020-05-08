# Trend Search Scraper

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]

## About the project

This project is the Capstone Solo project for the Ruby section of the Microverse curriculum. It utilizes various helpful gems like Nokogiri, geocoder ,and easy-translate to scrap [Google Trends XML page](https://trends.google.com/trends/trendingsearches/daily/rss?geo=US) for the latest trends for a given country.

## Requirements

- Once you download the project, please make sure that you have [Ruby](https://www.ruby-lang.org/en/) installed.
- Make sure to run `bundle` command in the terminal once you are in the working directory
- You'll also have to set up google API key if you need the translation feature as mentioned [below](#utilizing-the-translation-feature)
You should be good to go after verifying the above details 😄

## Features

Some of the features of this project include:

- Scraping Google trends XML for information

- Ability to change Country and Information limit

- Resetting values to default

- Translation of other languages to English if any (Requires Google Cloud API Key)

- Suggesting locations and prompting user based on country change input

## Technologies Used

- This project utilizes the Ruby programming language

- Ruby Gems:

  - gem 'geocoder'
  - gem 'nokogiri'
  - gem 'rest-client'
  - gem 'os'
  - gem 'easy_translate'
  - gem 'dotenv'

## Utilizing the translation feature

To be able to use the translation feature on one's system, you'll have to do the following:

- Gain access to the Translation API Key ([More Info](https://cloud.google.com/translate/))
- Place the key iside `.env_sample` file
- Rename the `.env_sample` file to `.env`

## Outputs

On the first run, the program produces the following output:

```ruby
$ ruby bin/main.rb

"Please choose your option:"
"1. Show Daily Trends from  United States"
"2. Show Trends from a different country"
"3. Change Number of Trends to Show"
"4. Reset country and number of trend"
"5 or 'q' to Quit"
```

On requesting a change in the country, the output is as follows:

```ruby
2
"Please enter the country name"
Jeju
"Did you mean South Korea? (y/n)"
```

Once the program gets a confirmation, the program proceeds as:

```ruby
"Country changed to South Korea!"


"Please choose your option:"
"1. Show Daily Trends from  South Korea"
"2. Show Trends from a different country"
"3. Change Number of Trends to Show"
"4. Reset country and number of trend"
"5 or 'q' to Quit"
```

Thus creating a loop until the user quits
<!-- 

## Testing

## Test Output

## Contributors -->

- Moin Khan
  - LinkedIn : [@MoinKhanIF](https://www.linkedin.com/in/moinkhanif/)
  - Personal Website: [MoinKhan.Info](https://moinkhan.info)
  - Twitter: [@MoinKhanIF](https://twitter.com/MoinKhanIF)
  
<!-- MARKDOWN LINKS & IMAGES -->

[contributors-shield]: https://img.shields.io/github/contributors/moinkhanif/enumerables.svg?style=flat-square
[contributors-url]: https://github.com/moinkhanif/enumerables/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/moinkhanif/enumerables.svg?style=flat-square
[forks-url]: https://github.com/moinkhanif/enumerables/network/members
[stars-shield]: https://img.shields.io/github/stars/moinkhanif/enumerables.svg?style=flat-square
[stars-url]: https://github.com/moinkhanif/enumerables/stargazers
[issues-shield]: https://img.shields.io/github/issues/moinkhanif/enumerables.svg?style=flat-square
[issues-url]: https://github.com/moinkhanif/enumerables/issues
