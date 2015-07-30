require 'pretty_weather_2'

describe PrettyWeather2::OpenWeather do
  before :each do
    PrettyWeather2.reset
    PrettyWeather2.configure do |config|
      config.city = 'Odesa'
      config.data_provider = :open_weather
      config.units = :metric
    end
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