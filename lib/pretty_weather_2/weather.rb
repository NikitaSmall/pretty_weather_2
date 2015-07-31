module PrettyWeather2
  # нужно разделить отвественность классов. Класс Weather не должен хранить данные, полученне от внешних провайдеров.
  # Значительно удобнее будет выделить отдельный класс (Forecast?) и хранить результаты в нем
  class Weather
    attr_accessor :config

    def initialize(city = nil, config = PrettyWeather2.configuration)
      @config = config
      @config.attempts_before_fallback = 1 if @config.attempts_before_fallback < 1
      @config.city = city unless city.nil?
      @weather_object = nil

      # 2. Реализациям клиентов для конкретного провайдера погоды не нужны знания о всей конфигурации нашего gem-а
    end

    # create instance before first time attempt to
    # get float temperature of current weather
    def temperature
      weather_object.temperature
    end

    # get short string summary about current weather
    def describe_weather
      weather_object.describe_weather
    end

    # time where object was created
    def created_at
      weather_object.created_at
    end

    # for debugging
    # В целом эта логика должны быть помещена в класс провайдера или резульата.
    # В этом случае в конкретных провайдерах можно будет реализовывать более сложную логику без изменения радительского класса.
    def with_errors?
      !!@weather_object.error
    end

    protected
    # create an instance of object (or get it if already exists)
    def weather_object
      create_weather_object(@config.data_provider) if @weather_object.nil?
      create_weather_object(@config.fallback_provider) if with_errors?
      @weather_object
      #@result
    end

    def create_weather_object(weather_class_symbol)
      class_name = generate_class_name weather_class_symbol
      @weather_object = PrettyWeather2.const_get(class_name).new(@config)
    end

    def generate_class_name(symbol)
      symbol.to_s.split("_").collect(&:capitalize).join
    end
  end
end