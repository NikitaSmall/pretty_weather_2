require 'pretty_weather_2'
require File.join(File.dirname(__FILE__), "spec_helper") # helper to stub requests


# не хватает тестов на переключение к fallback провайдеру при возникновении ошибки
# find these tests at optimistic_weather_spec,
# as OptimisticWeather instance has determinate parameters  of temperature and description.

describe PrettyWeather2 do
  describe '#configure' do
    before :each do
      PrettyWeather2.configure do |config|
        config.data_provider = :optimistic_weather
        config.units = :imperial
      end
    end

    it 'should show a weather in imperial units' do
      weather_object = PrettyWeather2::Weather.new

      expect(weather_object.config.units).to be_a(Symbol)
      expect(weather_object.config.units).to eq(:imperial)
    end
  end

  describe '#reset' do
    before :each do
      PrettyWeather2.configure do |config|
        config.units = :imperial
      end
    end

    it 'should reset the configurations' do
      PrettyWeather2.reset

      config = PrettyWeather2.configuration
      expect(config.units).to eq(:metric)
    end
  end

  # second way to set city
  describe '#initialize(city)' do
    before :each do
      PrettyWeather2.reset
      PrettyWeather2.configure do |config|
        config.data_provider = :open_weather
        config.city = 'Istambul' # default city
      end
    end

    it 'has higher priority than default city' do
      weather_object = PrettyWeather2::Weather.new('Constantinopolis')

      # Istambul non Constantinopolis
      expect(weather_object.config.city).to_not eq('Istambul')
      expect(weather_object.config.city).to eq('Constantinopolis')
    end
  end

  # not actual for now
  describe 'metaprogramming to avoid mistakes' do
    before :each do
      PrettyWeather2.configure do |config|
        config.city = 'Odesa'
        config.data_provider = :open_weatherer # you can't find such data provider
        config.fallback_provider = :optimistic_weather
        config.units = :metric
      end
    end

    it 'will fall down in any case' do
      PrettyWeather2.configure do |config|
        config.fallback_provider = :optimistic_weatherer # you can't find such data provider too
      end

      expect { PrettyWeather2::Weather.new.temperature }.to raise_error(NameError)
    end
  end
end