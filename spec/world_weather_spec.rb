require 'pretty_weather_2'

describe PrettyWeather2::WorldWeather do
  before :each do
    WebMock.disable_net_connect!
    stub_request(:get, "http://api.worldweatheronline.com/free/v2/weather.ashx?format=json&fx=no&key=2a034b1c63a5b6fec14c891fbe02d&q=Odesa").
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => open(File.join(File.dirname(__FILE__), "support/world_weather_odessa.json")), :headers => {})

    PrettyWeather2.reset
    PrettyWeather2.configure do |config|
      config.city = 'Odesa'
      config.data_provider = :world_weather
      config.fallback_provider = :optimistic_weather
      config.units = :imperial

      config.world_weather_api_key = '2a034b1c63a5b6fec14c891fbe02d'
    end

    @weather_object = PrettyWeather2::Weather.new
  end

  after :each do
    WebMock.allow_net_connect!
  end

  describe '.temperature' do
    it 'shows a temperature' do
      expect(@weather_object.temperature).to be_a(Float)
    end
  end

  describe '.describe_weather' do
    it 'shows a description' do
      expect(@weather_object.describe_weather).to be_a(String)
      expect(@weather_object.describe_weather).to_not eq(nil)
    end
  end
end
