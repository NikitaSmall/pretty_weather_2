class Railtie < Rails::Railtie
  initializer 'pretty_weather_2.configuration' do |app|
    app.config.pretty_weather_2 = PrettyWeather2::Configuration.new
  end
end