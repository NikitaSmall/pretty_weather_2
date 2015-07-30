module PrettyWeather2
  class Configuration
    attr_accessor :units, :data_provider, :fallback_provider, :city, :latitude, :longitude, :attempts_before_fallback
    attr_accessor :forecast_api_key, :world_weather_api_key # user should use his own key!

    def initialize
      @units = :metric
      @data_provider = :open_weather
      @fallback_provider = :optimistic_weather
      @city = 'Odesa'

      # coordinates for forecast.io api (Odessa coordinates is in comments)
      @latitude = nil # 46.482526
      @longitude = nil # 30.723310

      @attempts_before_fallback = 3

      # This is for you - I will delete this comments, but for now you don't need to register to get keys
      @forecast_api_key = nil # 'da01296688e16554f19b3161f69f158f'
      @world_weather_api_key = nil # '2a034b1c63a5b6fec14c891fbe02d'
    end

    def set_options(&block)
      block.yield(self)
    end
  end
end