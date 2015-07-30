module PrettyWeather2
  class OpenWeather
    attr_reader :error, :created_at

    # for weather describing
    WEATHERNAME = {
        '01d' => 'sunny',
        '01n' => 'moonly',
        '02d' => 'day cloud',
        '02n' => 'night cloud',
        '50d' => 'foggy',
        '50n' => 'foggy',
        '10d' => 'day rain',
        '10n' => 'night rain',
        '09d' => 'heavy rain',
        '09n' => 'heavy rain',
        '13d' => 'snow',
        '13n' => 'snow',
        '11d' => 'thunder',
        '11n' => 'thunder',
        '03d' => 'cloud',
        '03n' => 'cloud',
        '04d'=> 'cloud',
        '04n' => 'cloud'
    }

    def initialize(config)
      @config = config

      @created_at = Time.now.strftime('%Y-%m-%dT%H:%M:%S%z')
      @error = false
      collect_data
    end

    def temperature
      @temp_numeric
    end

    def describe_weather
      @weather
    end

    protected
    def collect_data
      link = "http://api.openweathermap.org/data/2.5/weather?q=#{@config.city}&mode=xml&units=#{@config.units.to_s}"

      # we have three attempts to get data.
      # In other way we will get an error
      # and gem will try to get weather info with fallback provider.

      # логика повторов запросов должна быть размещена в управляющем объекте, а не в реализации клиента
      # число повторов должно быть конфигуриемым
      attempts = @config.attempts_before_fallback
      begin
        data = Nokogiri::XML(open(link))

        @temp_numeric = data.xpath('//temperature')[0]['value'].to_f

        weather_code = data.xpath('//weather')[0]['icon']
        @weather = WEATHERNAME[weather_code] if WEATHERNAME.has_key?(weather_code)
      # Недостаточно обрабатывать только один тип ошибок. В случае, например, ошибки dns (SocketError)
      # exception не будет обработан и погода не будет запрошена у fallback провайдера

      rescue => e
        attempts -= 1
        retry unless attempts.zero?
        @error = true # check an error if we can't get openweather more than 3 times
      end
    end
  end
end