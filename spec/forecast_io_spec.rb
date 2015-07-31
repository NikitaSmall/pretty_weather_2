require 'pretty_weather_2'

describe PrettyWeather2::Forecast do
  before :each do
    PrettyWeather2.configure do |config|
      config.city = 'London'
      config.data_provider = :forecast
      config.units = :imperial

      config.forecast_api_key = 'da01296688e16554f19b3161f69f158f'
    end

    WebMock.disable_net_connect!

    # London at google maps api
    stub_request(:get, "http://maps.googleapis.com/maps/api/geocode/json?address=London&sensor=false").
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => open(File.join(File.dirname(__FILE__), "support/google_london.json")), :headers => {})

    # London at forecast io
    stub_request(:get, "https://api.forecast.io/forecast/da01296688e16554f19b3161f69f158f/51.5073509,-0.1277583,#{Time.now.strftime('%Y-%m-%dT%H:%M:%S%z')}").
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => open(File.join(File.dirname(__FILE__), "support/forecast_london.json")), :headers => {})


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
      expect(@weather_object.describe_weather).to_not eq('The weather is fine')
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
    before :each do
      WebMock.disable_net_connect!

      # Odessa at google maps api
      stub_request(:get, "http://maps.googleapis.com/maps/api/geocode/json?address=odesa&sensor=false").
          with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => open(File.join(File.dirname(__FILE__), "support/google_odessa.json")), :headers => {})
      # Odessa at forecast.io api
      stub_request(:get, "https://api.forecast.io/forecast/da01296688e16554f19b3161f69f158f/46.482526,30.7233095,#{Time.now.strftime('%Y-%m-%dT%H:%M:%S%z')}").
          with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => open(File.join(File.dirname(__FILE__), "support/forecast_odessa.json")), :headers => {})

    end

    after :each do
      WebMock.allow_net_connect!
    end

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