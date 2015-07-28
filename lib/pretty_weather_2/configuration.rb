module PrettyWeather2
  class Configuration
    attr_accessor :units, :data_provider, :fallback_provider, :city

    def initialize
      @units = :metric
      @data_provider = :open_weather
      @fallback_provider = :optimistic_weather
      @city = 'Odesa'
    end
  end
end