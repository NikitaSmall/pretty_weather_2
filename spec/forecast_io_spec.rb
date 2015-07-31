require 'pretty_weather_2'

describe PrettyWeather2::Forecast do
  before :each do
    PrettyWeather2.configure do |config|
      config.city = 'London'
      config.data_provider = :forecast
      config.units = :imperial

      config.forecast_api_key = 'da01296688e16554f19b3161f69f158f'
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

  describe '.collect_data' do
    it 'converts temperature to metric system during workflow' do
      PrettyWeather2.reset
      config = PrettyWeather2.configuration
      config.units = :metric
      config.city = 'London'
      config.data_provider = :forecast

      config.forecast_api_key = 'da01296688e16554f19b3161f69f158f'

      second_weather_object = PrettyWeather2::Weather.new(nil, config)
      expect(second_weather_object.temperature).to be < @weather_object.temperature
    end

    it 'gets correct coordinates from city name' do
      expect(@weather_object.config.longitude).to_not eq(nil)
      expect(@weather_object.config.latitude).to_not eq(nil)
      expect(@weather_object.config.latitude).to eq(51.5073509)
    end
  end

  describe 'Odessa weather with forecast' do
    it 'should find correct coordinates' do
      PrettyWeather2.reset
      PrettyWeather2.configure do |config|
        config.city = 'odesa'
        config.data_provider = :forecast
        config.units = :metric

        config.forecast_api_key = 'da01296688e16554f19b3161f69f158f'
      end

      @weather_object = PrettyWeather2::Weather.new
      @weather_object.temperature
      expect(@weather_object.config.latitude).to eq(46.482526)
    end
  end
end