require 'webmock/rspec'
WebMock.allow_net_connect!

# in this helper we stub all the test requests
=begin
require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  # 1. Глобальные стабы http запросов плохая практика.
  #    Запрет внешних запросов помогает не только ускорить тесты, но и убедиться, что приложение не шлет медленных запросов там, где это не нужно
  #    Соотвественно, должен использоваться подход "запрещено все что не разрешено явно". Разрешаться конкретные http запросы должны на уровне it или context, но не глобально.
  # 2. В случае, если нам нужны глобальные стабы, они должны быть вынесены в отдельный файл и помещены в scpe/support
  config.before(:each) do
    stub_request(:get, "http://maps.googleapis.com/maps/api/geocode/json?address=odesa&sensor=false").
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => open(File.join(File.dirname(__FILE__), "fixtures/google_odessa.json")), :headers => {})

    stub_request(:get, "https://api.forecast.io/forecast/da01296688e16554f19b3161f69f158f/46.482526,30.7233095,#{Time.now.strftime('%Y-%m-%dT%H:%M:%S%z')}").
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => open(File.join(File.dirname(__FILE__), "fixtures/forecast_odessa.json")), :headers => {})

    stub_request(:get, "http://api.worldweatheronline.com/free/v2/weather.ashx?format=json&fx=no&key=2a034b1c63a5b6fec14c891fbe02d&q=Odesa").
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => open(File.join(File.dirname(__FILE__), "fixtures/world_weather_odessa.json")), :headers => {})

    stub_request(:get, "http://maps.googleapis.com/maps/api/geocode/json?address=London&sensor=false").
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => open(File.join(File.dirname(__FILE__), "fixtures/google_london.json")), :headers => {})

    stub_request(:get, "https://api.forecast.io/forecast/da01296688e16554f19b3161f69f158f/51.5073509,-0.1277583,#{Time.now.strftime('%Y-%m-%dT%H:%M:%S%z')}").
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => open(File.join(File.dirname(__FILE__), "fixtures/forecast_london.json")), :headers => {})

    stub_request(:get, "http://api.openweathermap.org/data/2.5/weather?mode=xml&q=Odesa&units=metric").
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => open(File.join(File.dirname(__FILE__), "fixtures/open_weather_odessa.xml")), :headers => {})

    stub_request(:get, "http://api.openweathermap.org/data/2.5/weather?mode=xml&q=Moscow&units=imperial").
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => open(File.join(File.dirname(__FILE__), "fixtures/open_weather_moscow.xml")), :headers => {})

    stub_request(:get, "http://api.openweathermap.org/data/2.5/weather?mode=xml&q=London&units=imperial").
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => open(File.join(File.dirname(__FILE__), "fixtures/open_weather_london.xml")), :headers => {})
  end
end

=end
