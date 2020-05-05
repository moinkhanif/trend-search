require 'rspec'
require_relative '../lib/scraper'

RSpec.describe Scraper do
  let(:scraper) { Scraper.new('UG', 'Uganda') }

  describe '#num?' do
    it 'returns false if input is not a number' do
      expect(scraper.num?('myname')).to be false
    end

    it 'returns number if input is a number inside string' do
      expect(scraper.num?('123')).to eql(123)
    end
  end

  describe '#start' do
    it 'returns false when geocode out of scope' do
      scraperr = Scraper.new('UG', 'Uganda')
      expect(scraperr.scrap).to be false
    end
  end
end
