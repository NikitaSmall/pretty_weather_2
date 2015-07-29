class HomeController < ApplicationController
  def index
    @weather = PrettyWeather2::Weather.new
  end
end
