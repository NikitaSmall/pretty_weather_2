module PrettyWeather2
  class OptimisticWeather
    attr_reader :created_at

    # This was a test data_provider for PrettyWeather2 gem. It should be destroyed,
    # but as a fun of Monty Python, I can't just delete it. So it is easter egg for now.

    def initialize(config)
      @created_at = Time.now.strftime('%Y-%m-%dT%H:%M:%S%z')
      collect_data
    end

    def temperature
      42 # 42 is the answer for 'how many swallows to carry a coconut?' question, obviously.
    end

    def describe_weather
      'The weather is fine' # it is always fine at Camelot
    end

    def error
      false # there is no any errors
    end

    protected
    def collect_data
      'Let\'s not to go to Camelot. T\'is is silly place!'
    end
  end
end