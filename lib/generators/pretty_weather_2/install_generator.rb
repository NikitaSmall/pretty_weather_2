require 'Rails::Generators'

module PrettyWeather2
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)
      desc "Creates PrettyWeather2 initializer for your application"

      def copy_initialize
        template 'pretty_weather_2_initializer.rb', 'config/initializers/pretty_weather_2.rb'
      end
    end
  end
end