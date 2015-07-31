require 'pretty_weather_2'

describe PrettyWeather2::WorldWeather do
  before :each do
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
