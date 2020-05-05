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
  end
end
