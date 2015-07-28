require 'pretty_weather_2'

describe PrettyWeather2 do
  it 'should be a weather class' do
    weather_object = PrettyWeather2::Weather.new
    expect(weather_object.class).to eq(PrettyWeather2::Weather)
  end

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

  describe PrettyWeather2::Configuration do
    describe '#units' do
      it 'default units is :metric' do
        expect(PrettyWeather2.configuration.units).to  eq(:metric)
      end

      it 'default city is Odesa' do
        expect(PrettyWeather2.configuration.city).to  eq('Odesa')
      end

      it 'can set a value for units' do
        config = PrettyWeather2.configuration
        config.units = :imperial
        expect(config.units).to  eq(:imperial)
      end
    end
  end

  describe 'levels of visibility' do
    before :each do
      PrettyWeather2.configure do |config|
        config.city = 'Moscow' #this will be valid only for default configuration
      end
    end

    it 'should configure the one instance' do
      config = PrettyWeather2.configuration
      config.city = 'London'

      weather_object = PrettyWeather2::Weather.new(config)
      expect(weather_object.config.city).to eq('London')
    end

    it 'should take global options' do
      weather_object = PrettyWeather2::Weather.new
      expect(weather_object.config.city).to eq('Moscow')
    end
  end

  describe 'open_weather api works' do
    before :each do
      PrettyWeather2.configure do |config|
        config.city = 'Odesa'
        config.data_provider = :open_weather
        config.units = :metric
      end
    end

    it 'shows a temperature' do
      weather_object = PrettyWeather2::Weather.new

      expect(weather_object.temperature).to be_a(Float)
    end

    it 'shows a description' do
      weather_object = PrettyWeather2::Weather.new

      expect(weather_object.describe_weather).to be_a(String)
      expect(weather_object.describe_weather).to_not eq(nil)
    end

    it 'never makes errors' do
      weather_object = PrettyWeather2::Weather.new
      expect(weather_object.with_errors?).to eq(false)
    end
  end

  describe 'metaprogramming to avoid mistakes' do
    before :each do
      PrettyWeather2.configure do |config|
        config.city = 'Odesa'
        config.data_provider = :open_weatherer # you can't find such data provider
        config.fallback_provider = :optimistic_weather
        config.units = :metric
      end
    end

    it 'avoid errors with constants' do
      weather_object = PrettyWeather2::Weather.new

      expect(weather_object.with_errors?).to eq(false)
      expect(weather_object.temperature).to eq(42)
      expect(weather_object.describe_weather).to_not eq(nil)
    end

    it 'will fall down in any case' do
      PrettyWeather2.configure do |config|
        config.fallback_provider = :optimistic_weatherer # you can't find such data provider too
      end

      expect { PrettyWeather2::Weather.new }.to raise_error(RuntimeError, 'Class not found: OptimisticWeatherer')
    end
  end
end