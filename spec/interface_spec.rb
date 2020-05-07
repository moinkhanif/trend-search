require 'rspec'
require_relative '../lib/scraper'

RSpec.describe Scraper do
  let(:scraper) { Scraper.new('UG', 'Uganda') }

  describe '#news_display' do
    it 'returns false if no news displayed' do
      expect(scraper.news_display(100)).to be false
    end
  end

  describe 'menu_controller' do
    it 'quits the game with thank you message' do
      expect { scraper.menu_controller('q') }.to output("\"Thank you for using Trend Search! Good day!\"\n").to_stdout
    end

    it 'resets country to US and trend to 5' do
      allow(scraper).to receive(:menu)
      expect { scraper.menu_controller('4') }.to output("\n\"Country has been reset to United States and number of trends to 5\"\n").to_stdout
    end
  end

  describe 'news_menu_control' do
    before do
      @t = 5
    end

    it 'confirms link open' do
      allow(scraper).to receive(:news_menu)
      expect { scraper.news_menu_control('10') }.to output("\"Invalid Input, please try again!\"\n").to_stdout
    end
  end
end
