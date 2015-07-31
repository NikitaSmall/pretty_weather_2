module PrettyWeather2
  class WeatherResult
    attr_accessor :current_temperature, :current_description, :error, :created_at

    def initialize(temperature, description, error)
      @current_temperature = temperature
      @current_description = description
      @created_at = Time.now.strftime('%Y-%m-%dT%H:%M:%S%z')
      @error = error
    end

    def temperature
      @current_temperature
    end

    def describe_weather
      @current_description
    end
  end
end
