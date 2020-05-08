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

  describe '#scrap' do
    before do
      @country = 'UG'
      @country_name = 'Uganda'
    end
    it 'returns false when geocode out of scope' do
      allow(scraper).to receive(:country_change)
      expect { scraper.scrap }.to output("\"No information available from Google trends regarding Uganda!\"\n").to_stdout
    end
  end
end
