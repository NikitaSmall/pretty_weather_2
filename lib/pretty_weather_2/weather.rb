module PrettyWeather2
  class Weather
    attr_accessor :config

    def initialize(config = PrettyWeather2.configuration)
      @config = config

      # this terrible string is for creating a new instance of data_provider class
      class_name = @config.data_provider.to_s.split("_").collect(&:capitalize).join
      @weather_object = eval "#{class_name}.new(@config)"

      # if weather object has some errors (in attempt to get unavailable site) we will try to use other data provider
      if @weather_object.error
        class_name = @config.fallback_provider.to_s.split("_").collect(&:capitalize).join
        @weather_object = eval "#{class_name}.new(@config)"
      end
    end

    def temperature
      @weather_object.temperature
    end

    def describe_weather
      @weather_object.describe_weather
    end

    def with_errors?
      return true if @weather_object.error
      false
    end

    def self.const_missing(name)
      config = PrettyWeather2.configuration
      class_name = config.fallback_provider.to_s.split("_").collect(&:capitalize).join.to_sym
      return eval "#{class_name}.new(@config).class" unless class_name == name
      raise "Class not found: #{name}"
    end
  end
end