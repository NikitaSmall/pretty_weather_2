module PrettyWeather2
  class WorldWeather
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
      query = "#{@config.latitude},#{@config.longitude}"
      query = @config.city if @config.latitude.nil? || @config.longitude.nil?

      link = "http://api.worldweatheronline.com/free/v2/weather.ashx?key=#{@config.world_weather_api_key}&format=json&fx=no&q=#{query}"

      attempts = 3
      begin
        data = JSON.load(open(link))

        @temperature = data['data']['current_condition'][0]['temp_F'].to_f if @config.units == :imperial
        @temperature = data['data']['current_condition'][0]['temp_C'].to_f if @config.units == :metric

        @weather = data['data']['current_condition'][0]['weatherDesc'][0]['value'] # get weather description
      rescue OpenURI::HTTPError => e
        attempts -= 1
        retry unless attempts.zero?
        @error = true # check an error if we can't get forecast.io more than 3 times
      end
    end
  end
end