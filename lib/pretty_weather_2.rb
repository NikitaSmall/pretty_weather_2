require 'pretty_weather_2/version'
require 'pretty_weather_2/weather'
require 'pretty_weather_2/optimistic_weather'
require 'pretty_weather_2/open_weather'
require 'pretty_weather_2/forecast'
require 'pretty_weather_2/world_weather'
require 'pretty_weather_2/configuration'
require 'pretty_weather_2/coordinates_mapper'
# require 'pretty_weather_2/weather_result'

require 'pretty_weather_2/railtie' if defined?(Rails)
require 'pretty_weather_2/engine' if defined?(Rails)
# require 'generators/pretty_weather_2/install_generator' if defined?(Rails)

require 'nokogiri'
require 'open-uri'
require 'json'

module PrettyWeather2
  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
