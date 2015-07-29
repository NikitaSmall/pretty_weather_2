require 'rails' if defined?(Rails)

module PrettyWeather2
  module Generators # doesn't work. I haven't time (as this is additional task and nobody talks about it)
    # but it registered
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)
      desc "Creates PrettyWeather2 initializer for your application"

      def copy_initialize
        template 'pretty_weather_2_initializer.rb', 'config/initializers/pretty_weather_2.rb'
      end
    end
  end
end