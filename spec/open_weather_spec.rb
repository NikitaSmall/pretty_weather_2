require 'pretty_weather_2'

describe PrettyWeather2::OpenWeather do
  before :each do
    WebMock.disable_net_connect!
    stub_request(:get, "http://api.openweathermap.org/data/2.5/weather?mode=xml&q=Odesa&units=metric").
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => open(File.join(File.dirname(__FILE__), "support/open_weather_odessa.xml")), :headers => {})
    PrettyWeather2.reset
    PrettyWeather2.configure do |config|
      config.city = 'Odesa'
      config.data_provider = :open_weather
      config.units = :metric
    end
  end

  after :each do
    WebMock.allow_net_connect!
  end

  describe '.temperature' do
    it 'shows a temperature' do
      weather_object = PrettyWeather2::Weather.new

      expect(weather_object.temperature).to be_a(Float)
    end
  end

  describe '.describe_weather' do
    it 'shows a description' do
      weather_object = PrettyWeather2::Weather.new

      expect(weather_object.describe_weather).to be_a(String)
      expect(weather_object.describe_weather).to_not eq(nil)
    end
  end
end