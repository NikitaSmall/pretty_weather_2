require 'pretty_weather_2'

describe PrettyWeather2::CoordinatesMapper do
  describe '#.get_coordinates_by_city' do
    before :each do
      # I had my Internet connection broken, so I decide that local stubbing is a best way to check tests
      WebMock.disable_net_connect!

      stub_request(:get, "http://maps.googleapis.com/maps/api/geocode/json?address=London&sensor=false").
          with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => open(File.join(File.dirname(__FILE__), "support/google_london.json")), :headers => {})
    end

    after :each do
      WebMock.allow_net_connect!
    end

    it 'returns array of two elements' do
      expect(PrettyWeather2::CoordinatesMapper.get_coordinates_by_city('London').count).to eq(2)
    end

    it 'returns correct coordinates' do
      expect(PrettyWeather2::CoordinatesMapper.get_coordinates_by_city('London')[0]).to_not eq(nil)
      expect(PrettyWeather2::CoordinatesMapper.get_coordinates_by_city('London')[1]).to eq(-0.1277583)
    end
  end
end