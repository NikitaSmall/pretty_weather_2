module PrettyWeather2
  class WeatherResult
    attr_accessor :current_temperature, :current_description, :error, :created_at

    def initialize
      @current_temperature = nil
      @current_description = nil
      @created_at = nil
      @error = false
    end

    def temperature
      @current_temperature
    end

    def describe_weather
      @current_description
    end

    def created_at
      @created_at
    end
  end
end
