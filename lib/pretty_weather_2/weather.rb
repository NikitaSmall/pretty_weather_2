module PrettyWeather2
  # нужно разделить отвественность классов. Класс Weather не должен хранить данные, полученне от внешних провайдеров.
  # Значительно удобнее будет выделить отдельный класс (Forecast?) и хранить результаты в нем
  class Weather
    attr_accessor :config

    def initialize(config = PrettyWeather2.configuration)
      @config = config
      @config.attempts_before_fallback = 1 if @config.attempts_before_fallback < 1

      @weather_object = nil

      # Дублирование кода для default и fallback провайдера
      # class_name = generate_class_name @config.data_provider
      # 1. eval -- плохой и небезопасный выбор для иснтанцирования класса. Нужно использовать const_get
      # 2. Реализациям клиентов для конкретного провайдера погоды не нужны знания о всей конфигурации нашего gem-а
      # 3. Неправильно сразу же при создании объекта выполнять дополнительную работую.
      #    Тем более такую продолжительную, как внешний http запрос. Само инстанцирование провайдера стоит вынести в метод,
      #    который будет взываться при первом обращении к данным.
      #    def temperature
      #      weather_object.temperature
      #    end
      #
      #    def weather_object
      #      @weather_object ||= begin
      #        ...
      #      end
      #    end
      #
    end


    # Следующие три метода можно заменить на def_delegators
    # @see http://ruby-doc.org/stdlib-2.0.0/libdoc/forwardable/rdoc/Forwardable.html

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

    # def with_errors?
    #   !!@weather_object.error # or !@weather_object.error.nil?
    # end
    # В целом эта логика должны быть помещена в класс провайдера или резульата.
    # В этом случае в конкретных провайдерах можно будет реализовывать более сложную логику без изменения радительского класса.

    def with_errors?
      !!@weather_object.error
    end

    # in attempt to avoid error in mistyping of data provider name - canceled

    # Автоматическое переключение на fallback провайдера -- очень плохая идея.
    # Как разработчик, если я опечатался в названии провайдера, то хочу узнать об этом при первом запуске приложения на dev машине,
    # а не из жалоб production пользователей о неточных прогнозах.
    # def self.const_missing(name)
    #   config = PrettyWeather2.configuration
    #   class_name = config.fallback_provider.to_s.split("_").collect(&:capitalize).join.to_sym
    #   return eval "#{class_name}.new(@config).class" unless class_name == name
    #   raise "Class not found: #{name}"
    # end

    protected
    def generate_class_name(symbol)
      symbol.to_s.split("_").collect(&:capitalize).join
    end

    def weather_object
      create_weather_object(@config.data_provider) if @weather_object.nil?
      create_weather_object(@config.fallback_provider) if with_errors?
      @weather_object
    end

    def create_weather_object(weather_class_symbol)
      class_name = generate_class_name weather_class_symbol
      @weather_object = PrettyWeather2.const_get(class_name).new(@config)
    end
  end
end