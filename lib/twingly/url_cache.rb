require "twingly/url_cache/version"
require "dalli"
require "digest"
require "retryable"

module Twingly
  class UrlCache
    TTL = nil
    CACHE_VALUE = ""

    def initialize
      @cache = Dalli::Client.new(servers, options)
    end

    def cache!(url)
      key = key_for(url)
      Retryable.retryable(tries: 3, on: Dalli::RingError) do
        !!@cache.set(key, CACHE_VALUE, TTL, raw: true)
      end
    end

    def cached?(url)
      key = key_for(url)
      Retryable.retryable(tries: 3, on: Dalli::RingError) do
        @cache.get(key, raw: true) == CACHE_VALUE
      end
    end

    private

    def key_for(url)
      Digest::MD5.digest(url)
    end

    def options
      {
        username: ENV.fetch("MEMCACHIER_USERNAME") { },
        password: ENV.fetch("MEMCACHIER_PASSWORD") { },
        failover: true,
        socket_timeout: 1.5,
        socket_failure_delay: 0.2
      }
    end

    def servers
      ENV.fetch("MEMCACHIER_SERVERS").split(",")
    end
  end
end

