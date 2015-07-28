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
:optimistic_weather # for easter egg
```

The same data providers can be used as fallback_provider - an additional source.
It can be useful in situations with unavailable sites.
To manage these options you can create initializer like this:

```ruby
  PrettyWeather2.configure do |config|
    config.city = 'Odesa'
    config.data_provider = :open_weather
    config.fallback_provider = :optimistic_weather
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

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake false` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/pretty_weather_2.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

