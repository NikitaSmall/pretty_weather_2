module PrettyWeather2
  class WorldWeather
    attr_reader :created_at

    def initialize(config)
      @config = config

      @created_at = Time.now.strftime('%Y-%m-%dT%H:%M:%S%z')
      @error = false
      collect_data

      save_data
    end

    def temperature
      @result.current_temperature
    end

    def describe_weather
      @result.current_description
    end

    def error
      @result.error
    end

    protected
    def collect_data
      # error if no api key provided
      if @config.world_weather_api_key.nil?
        @error = true
        return
      end
      query = "#{@config.latitude},#{@config.longitude}" # make query with coordinates
      query = @config.city if @config.latitude.nil? || @config.longitude.nil? # with city, if one of coordinates is nil

      link = "http://api.worldweatheronline.com/free/v2/weather.ashx?key=#{@config.world_weather_api_key}&format=json&fx=no&q=#{query}"

      attempts = @config.attempts_before_fallback
      begin
        data = JSON.load(open(link))

        @temperature = data['data']['current_condition'][0]['temp_F'].to_f if @config.units == :imperial
        @temperature = data['data']['current_condition'][0]['temp_C'].to_f if @config.units == :metric

        @weather = data['data']['current_condition'][0]['weatherDesc'][0]['value'] # get weather description

        @error = true if @temperature.nil? || @weather.nil?
      rescue => e
        attempts -= 1
        retry unless attempts.zero?
        @error = true # check an error if we can't get forecast.io more than 3 times
      end
    end

    def save_data
      @result = PrettyWeather2::WeatherResult.new(@temperature, @weather, @error)
      @result.created_at = @created_at
    end
  end
end