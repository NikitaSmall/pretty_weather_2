module PrettyWeather2
  class Forecast
    # Класс PrettyWeather2::Forecast запрашивает прогноз погоды у forecast.io _И_ определяет координаты города
    # у класса должна быть одна отвественность.
    attr_reader :error, :created_at

    def initialize(config)
      @config = config

      @created_at = Time.now.strftime('%Y-%m-%dT%H:%M:%S%z')
      @error = false
      collect_data
    end

    def temperature
      @temperature
    end

    def describe_weather
      @weather
    end

    protected
    def collect_data
      # error if no api key provided
      if @config.forecast_api_key.nil?
        @error = true
        return
      end

      attempts = @config.attempts_before_fallback
      begin
        # block to get coordinates if one of them is not represented
        if @config.latitude.nil? || @config.longitude.nil?
          @config.latitude, @config.longitude = PrettyWeather2::CoordinatesMapper.get_coordinates_by_city(@config.city)
        end

        link = "https://api.forecast.io/forecast/#{@config.forecast_api_key}/#{@config.latitude},#{@config.longitude},#{@created_at}"
        data = JSON.load(open(link))

        @temperature = data['currently']['temperature'].to_f
        @temperature = (@temperature - 32) / 1.8 if @config.units == :metric # get temperature to metric system if necessary

        @weather = data['currently']['icon'] # get weather description (actually, description of weather icon)

        @error = true if @temperature.nil? || @weather.nil?
      rescue => e
        attempts -= 1
        retry unless attempts.zero?
        @error = true # check an error if we can't get forecast.io more than 3 times
      end
    end
  end
end