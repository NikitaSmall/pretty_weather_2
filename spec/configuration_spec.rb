require 'pretty_weather_2'

describe PrettyWeather2::Configuration do
  before :each do
    WebMock.disable_net_connect!
  end

  after :each do
    WebMock.allow_net_connect!
  end
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

  describe 'levels of visibility' do
    before :each do
      PrettyWeather2.configure do |config|
        config.city = 'Moscow' #this will be valid only for default configuration
      end
    end

    it 'should configure the one instance' do
      config = PrettyWeather2.configuration
      config.city = 'London'

      weather_object = PrettyWeather2::Weather.new(nil, config)
      expect(weather_object.config.city).to eq('London')
    end

    it 'should take global options' do
      weather_object = PrettyWeather2::Weather.new
      expect(weather_object.config.city).to eq('Moscow')
    end
  end
end