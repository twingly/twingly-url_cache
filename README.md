# Twingly::UrlCache

[![Build Status](https://travis-ci.org/twingly/twingly-url_cache.svg)](https://travis-ci.org/twingly/twingly-url_cache)

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

Optional environment variables:

```Shell
MEMCACHIER_SERVERS # Defaults to localhost
MEMCACHIER_PASSWORD
MEMCACHIER_USERNAME
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Start memcached. Then, run `bundle exec rake` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Release workflow

* Bump the version in `lib/twingly/url_cache/version.rb` in a commit, no need to push (the release task does that).

* Build and [publish](http://guides.rubygems.org/publishing/) the gem. This will create the proper tag in git, push the commit and tag and upload to RubyGems.

        bundle exec rake release

    * If you are not logged in as [twingly][twingly-rubygems] with ruby gems, the rake task will fail and tell you to set credentials via `gem push`, do that and run the `release` task again. It will be okay.

* Update the changelog with [GitHub Changelog Generator](https://github.com/skywinder/github-changelog-generator/) (`gem install github_changelog_generator` if you don't have it, set `CHANGELOG_GITHUB_TOKEN` to a personal access token to avoid rate limiting by GitHub). This command will update `CHANGELOG.md`, commit and push manually.

        github_changelog_generator -u twingly -p twingly-url_cache

[twingly-rubygems]: https://rubygems.org/profiles/twingly

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/twingly/twingly-url_cache.
