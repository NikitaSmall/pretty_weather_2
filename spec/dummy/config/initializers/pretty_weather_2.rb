PrettyWeather2.configure do |config|
  config.city = 'Odesa'
  config.data_provider = :world_weather
  config.fallback_provider = :optimistic_weather
  config.latitude = 46.482526
  config.longitude = 30.723310
  config.units = :metric

  # to manage keys:
  config.forecast_api_key = 'da01296688e16554f19b3161f69f158f'
  config.world_weather_api_key = '2a034b1c63a5b6fec14c891fbe02d'
end