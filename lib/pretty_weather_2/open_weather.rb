module PrettyWeather2
  class OpenWeather
    attr_reader :error

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
      link = "http://api.openweathermap.org/data/2.5/weather?q=#{@config.city}&mode=xml&units=#{@config.units}"

      attempts = 3
      @updated_at = Time.now

      begin
        data = Nokogiri::XML(open(link))

        @temp_numeric = data.xpath('//temperature')[0]['value'].to_f

        weather_code = data.xpath('//weather')[0]['icon']
        @weather = WEATHERNAME[weather_code] if WEATHERNAME.has_key?(weather_code)
      rescue OpenURI::HTTPError => e
        attempts -= 1
        retry unless attempts.zero?
        @error = true # create an error if we can't get openweather more than 3 times
      end
    end
  end
end