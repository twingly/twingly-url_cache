# Twingly::UrlCache

URL cache, remember if an URL been seen before. Uses [Memcached] to cache data, prefers [MemCachier].

[Memcached]: http://memcached.org/
[MemCachier]: https://www.memcachier.com/

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'twingly-url_cache'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install twingly-url_cache

## Usage

Initialize an instance, cache an URL with `#cache!` and look if it's cached with `#cached?`.

```Ruby
[1] pry(main)> cache = Twingly::UrlCache.new
=> #<Twingly::UrlCache:0x007fd58c96b978 ...>
[2] pry(main)> cache.cache!("http://www.twingly.com/")
=> true
[3] pry(main)> cache.cached?("http://www.twingly.com/")
=> true
[4] pry(main)> cache.cached?("http://blog.twingly.com/")
=> false
```

Required environment variables:

```Shell
MEMCACHIER_SERVERS
MEMCACHIER_PASSWORD
MEMCACHIER_USERNAME
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Start memcached. Then, run `bundle exec rake` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/twingly/twingly-url_cache.

