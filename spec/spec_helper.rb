=begin
require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.before(:each) do
    stub_request(:get, "http://maps.googleapis.com/maps/api/geocode/json?address=odesa&sensor=false").
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => '{
           "results" : [
              {
                 "geometry" : {
                    "location" : {
                       "lat" : 46.482526,
                       "lng" : 30.7233095
                    }
              }
           ]
        }', :headers => {})
  end
end
=end