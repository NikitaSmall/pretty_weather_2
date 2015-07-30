require 'pretty_weather_2'
require File.join(File.dirname(__FILE__), "spec_helper") # helper to stub requests

# не хватает тестов на переключение к fallback провайдеру при возникновении ошибки


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

  # почему тесты для нескольких классов в водном файле?
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

  # Здесь тестируется не PrettyWeather2::Weather, а класс конкретного провайдера
  # соотвтственно, этот тест должен быть изолирован и вынесен в отдельный файл.
  # то же самое для других провайдеров
  describe 'open_weather api works' do
    before :each do
      PrettyWeather2.configure do |config|
        config.city = 'Odesa'
        config.data_provider = :open_weather
        config.units = :metric
      end
    end


    # Замечание по самому именованию it "..."
    # метод #created_at ничего не показывает -- он возвращает значение
    # Также есть общепринятое правило для именования спеков для конкретного метода
    # describe ClassName do
    #   describe "#instance_method" do
    #     it ...
    #   end
    #   describe ".class_method" do
    #     it ...
    #   end
    # end
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

  describe 'forecast.io api works' do
    before :each do
      PrettyWeather2.configure do |config|
        config.city = 'London'
        config.data_provider = :forecast
        config.units = :imperial

        # do this to search by the city name
        # config.latitude = nil
        # config.longitude = nil
      end

      @weather_object = PrettyWeather2::Weather.new
    end

    it 'shows current time' do
      expect((@weather_object.created_at.to_f - Time.now.strftime('%Y-%m-%dT%H:%M:%S%z').to_f).abs).to be < 2
    end

    it 'shows coordinates from city name' do
      expect(@weather_object.config.longitude).to_not eq(nil)

      expect(@weather_object.config.latitude).to_not eq(nil)
      # Проверка "не равно ожидаемому значению" очень слабая (то же число, но строкой/+1 знак после запятой).
      # Нужно использовать проверки на равенство ожидаемому результату
      expect(@weather_object.config.latitude).to_not eq(46.482526)
    end

    it 'shows the temperature' do
      expect(@weather_object.temperature).to be_a(Float)
    end

    it 'describes the weather state' do
      expect(@weather_object.describe_weather).to be_a(String)
    end

    it 'converts temperature to metric system' do
      config = PrettyWeather2.configuration
      config.units = :metric
      config.city = 'London'
      config.data_provider = :forecast

      second_weather_object = PrettyWeather2::Weather.new(config)
      expect(second_weather_object.temperature).to be < @weather_object.temperature
    end
  end

  describe 'World Weather api' do
    before :each do
      PrettyWeather2.reset
      PrettyWeather2.configure do |config|
        config.city = 'Odesa'
        config.data_provider = :world_weather
        config.units = :metric
      end

      @weather_object = PrettyWeather2::Weather.new
    end

    it 'shows correct temperature' do
      expect(@weather_object.temperature).to be_a(Float)
    end

    it 'describes the weather state' do
      expect(@weather_object.describe_weather).to be_a(String)
    end
  end

  describe 'Odessa weather with forecast' do
    before :each do
      PrettyWeather2.reset

      PrettyWeather2.configure do |config|
        config.city = 'odesa'
        config.data_provider = :forecast
        config.units = :metric
      end

      @weather_object = PrettyWeather2::Weather.new
    end

    it 'should find correct coordinates' do
      expect(@weather_object.config.latitude).to eq(46.482526)
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