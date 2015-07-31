module PrettyWeather2
  class CoordinatesMapper
    def self.get_coordinates_by_city(city)
      # getting coordinates from google maps api
      link_to_get_city = "http://maps.googleapis.com/maps/api/geocode/json?address=#{city}&sensor=false"

      data = JSON.load(open(link_to_get_city))

      coordinates = data['results'][0]['geometry']['location']
      latitude = coordinates['lat'].to_f
      longitude = coordinates['lng'].to_f

      [latitude, longitude]
    end
  end
end