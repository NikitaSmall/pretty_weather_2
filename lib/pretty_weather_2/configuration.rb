module PrettyWeather2
  class Configuration
    attr_accessor :units, :data_provider, :fallback_provider, :city, :latitude, :longitude
    attr_accessor :forecast_api_key, :world_weather_api_key # user should use his own key!

    def initialize
      @units = :metric
      @data_provider = :open_weather
      @fallback_provider = :optimistic_weather
      @city = 'Odesa'

      # coordinates for forecast.io api (Odessa coordinates is in comments)
      @latitude = nil # 46.482526
      @longitude = nil # 30.723310

      @forecast_api_key = 'da01296688e16554f19b3161f69f158f'
      @world_weather_api_key = '2a034b1c63a5b6fec14c891fbe02d'
    end
  end
end