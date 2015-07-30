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

      attempts = 3
      begin
        # block to get coordinates if one of them is not represented
        if @config.latitude.nil? || @config.longitude.nil?
          # getting coordinates from google maps api

          # геолокация не относится к отвественности этого класса
          link_to_get_city = "http://maps.googleapis.com/maps/api/geocode/json?address=#{@config.city}&sensor=false"

          data = JSON.load(open(link_to_get_city))

          coordinates = data['results'][0]['geometry']['location']
          @config.latitude = coordinates['lat'].to_f
          @config.longitude = coordinates['lng'].to_f
        end

        link = "https://api.forecast.io/forecast/#{@config.forecast_api_key}/#{@config.latitude},#{@config.longitude},#{@created_at}"
        data = JSON.load(open(link))

        @temperature = data['currently']['temperature'].to_f
        @temperature = (@temperature - 32) / 1.8 if @config.units == :metric # get temperature to metric system if necessary

        @weather = data['currently']['icon'] # get weather description (actually, description of weather icon)
      rescue OpenURI::HTTPError => e
        attempts -= 1
        retry unless attempts.zero?
        @error = true # check an error if we can't get forecast.io more than 3 times
      end
    end
  end
end