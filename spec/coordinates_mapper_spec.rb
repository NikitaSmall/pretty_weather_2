require 'pretty_weather_2'

describe PrettyWeather2::CoordinatesMapper do
  describe '#.get_coordinates_by_city' do
    before :each do
      # WebMock.allow_net_connect!
      WebMock.disable_net_connect!(allow: "maps.googleapis.com")
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