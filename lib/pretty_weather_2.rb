require 'pretty_weather_2/version'
require 'pretty_weather_2/weather'
require 'pretty_weather_2/optimistic_weather'
require 'pretty_weather_2/open_weather'
require 'pretty_weather_2/forecast'
require 'pretty_weather_2/world_weather'
require 'pretty_weather_2/configuration'

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
