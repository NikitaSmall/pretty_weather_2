require 'pretty_weather_2'
require 'webmock/rspec'


# as a determinate case of fallback provider (we will know all the answers)

describe PrettyWeather2::OptimisticWeather do
  describe '.temperature' do
    before :each do
      WebMock.disable_net_connect!
      stub_request(:get, "https://api.forecast.io/forecast/da01296688e16554f19b3161f69f158f/45.482526,20.72331,#{Time.now.strftime('%Y-%m-%dT%H:%M:%S%z')}").
          with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => "can't take any useful info!", :headers => {})

    end

    after :each do
      WebMock.allow_net_connect!
    end

    it 'will show 42 with wrong http response' do
      PrettyWeather2.reset
      PrettyWeather2.configure do |config|

        config.latitude = 45.482526
        config.longitude = 20.723310

        config.data_provider = :forecast
        config.fallback_provider = :optimistic_weather
        config.units = :imperial

        config.forecast_api_key = 'da01296688e16554f19b3161f69f158f'
      end

      @weather_object = PrettyWeather2::Weather.new
      expect(@weather_object.temperature).to eq(42)
    end
  end
end