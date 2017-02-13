# Redis storage plugin for Fluent

fluent-plugin-storage-redis is a fluent plugin to store plugin state into redis.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fluent-plugin-storage-redis'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fluent-plugin-storage-redis

Then fluent automatically loads the plugin installed.

## Configuration

```aconf
<store>
  @type redis

  path my_key # or conf.arg will be used as redis key
  host localhost     # localhost is default
  port 6379          # 6379 is default
  db_number 0        # 0 is default
  # If requirepass is set, please specify this.
  # password hogefuga
</match>
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cosmo0920/fluent-plugin-storage-redis.

## Copyright

Copyright (c) 2017- Hiroshi Hatake

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
