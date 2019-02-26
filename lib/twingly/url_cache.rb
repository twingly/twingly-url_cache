require "twingly/url_cache/version"
require "dalli"
require "digest"
require "retryable"

module Twingly
  class UrlCache
    class Error < StandardError; end
    class ServerError < Error; end

    attr_reader :ttl

    CACHE_VALUE = ""

    def initialize(ttl: 0)
      @cache = with_memcached_exception_handling_and_retries do
        Dalli::Client.new(servers, options)
      end

      @ttl = ttl
    end

    def cache!(url)
      key = key_for(url)

      with_memcached_exception_handling_and_retries do
        !!@cache.set(key, CACHE_VALUE, ttl, raw: true)
      end
    end

    def cached?(url)
      key = key_for(url)

      with_memcached_exception_handling_and_retries do
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
        socket_failure_delay: 0.2,
      }
    end

    def servers
      ENV.fetch("MEMCACHIER_SERVERS") { "localhost" }.split(",")
    end

    def with_memcached_exception_handling_and_retries(&block)
      retry_transient_exceptions(&block)
    rescue Dalli::RingError => error
      raise ServerError, error.message
    rescue Dalli::DalliError => error
      raise Error, error.message
    end

    def retry_transient_exceptions(&block)
      Retryable.retryable(tries: 3, on: Dalli::RingError, &block)
    end
  end
end
