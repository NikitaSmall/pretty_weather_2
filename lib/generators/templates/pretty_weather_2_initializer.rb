PrettyWeather2.configure do |config|
  config.city = 'Odesa'
  config.data_provider = :open_weather
  config.fallback_provider = :optimistic_weather
  config.latitude = 46.482526
  config.longitude = 30.723310
  config.units = :metric

  # to manage keys:
  config.forecast_api_key = 'your forecast.io api key'
  config.world_weather_api_key = 'your WorldWeatherOnline api key'
end