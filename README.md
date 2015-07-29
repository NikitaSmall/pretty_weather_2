# PrettyWeather2

This is improved, more clear and flexible version of pretty_weather gem.
Now it is cleared from ui helpers.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pretty_weather_2'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install pretty_weather_2

Next, you may set initializer for default city to know the current weather in it.
You may specify units: metric for celsius, imperial for fahrenheit temperature scale.
Also you may specify a data_provider - a source of weather information. It can be:

```ruby
:open_weather # for OpenWeather api
:forecast # for forecast.io api
:world_weather # for WorldWeatherOnline api
:optimistic_weather # for easter egg
```

The same data providers can be used as fallback_provider - an additional source.
It can be useful in situations with unavailable sites.
To use WorldWeather or Forecast.io you need to have your own api key!
To manage these options you can create initializer like this:

```ruby
  PrettyWeather2.configure do |config|
    config.city = 'Odesa'
    config.data_provider = :open_weather
    config.fallback_provider = :optimistic_weather
    config.units = :metric
    # to manage keys:
    config.forecast_api_key = 'your forecast.io api key'
    config.world_weather_api_key = 'your WorldWeatherOnline api key'
  end
```

Also you may specify coordinates to work with forecast.io with more accuracy.
Coordinates work only with forecast.io api for now. For all other data providers they will be ignored.
For forecast.io coordinates have higher priority to get information.
To set the coordinates:

```ruby
  PrettyWeather2.configure do |config|
    config.city = 'Odesa'
    config.data_provider = :forecast
    config.latitude = 46.482526
    config.longitude = 30.723310
    config.units = :metric
  end
```

## Usage

To use weather information from any data-source you should create weather object:

```ruby
@weather_object = PrettyWeather2::Weather.new
```

After creation of this object you can retrieve the following information from the Internet:

```ruby
@weather_object.temperature # to get float number of current temperature
@weather_object.describe_weather # to get short string with description of current weather
```

If you want to get special information of data_object,
such as config params (city, data_provider, or coordinates that were found automatically)
you may access them this way:

```ruby
@weather_object.config.data_provider # to get symbol of data provider
@weather_object.config.latitude # to get coordinates
@weather_object.config.longitude
```

Also you can to set uniq configs for lonely instance. To do so you need to create a new config instance.
Here is a way to configure different instance (and for different cities):

```ruby
config = PrettyWeather2.configuration
config.units = :metric
config.city = 'London'
first_weather_object = PrettyWeather2::Weather.new(config)
config.city = 'Odesa'
second_weather_object = PrettyWeather2::Weather.new(config)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake false` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/NikitaSmall/pretty_weather_2.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

