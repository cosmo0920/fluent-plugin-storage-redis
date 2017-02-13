require 'redis'
require 'fluent/plugin/storage'

module Fluent
  module Plugin
    class RedisStorage < Storage
      Fluent::Plugin.register_storage('redis', self)

      config_param :path, :string, default: nil
      config_param :host, :string, default: 'localhost'
      config_param :port, :integer, default: 6379
      config_param :db_number, :integer, default: 0
      config_param :password, :string, default: nil, secret: true

      attr_reader :store # for test

      def initialize
        super

        @store = {}
      end

      def configure(conf)
        super

        unless @path
          if conf && !conf.arg.empty?
            @path = conf.arg
          else
            raise Fluent::ConfigError, "path or conf.arg for <storage> is required."
          end
        end

        options = {
          host: @host,
          port: @port,
          thread_safe: true,
          db: @db_number
        }
        options[:password] = @password if @password

        @redis = Redis.new(options)
      end

      def multi_workers_ready?
        true
      end

      def load
        begin
          json_string = @redis.get(@path)
          json = Yajl::Parser.parse(json_string)
          unless json.is_a?(Hash)
            log.error "broken content for plugin storage (Hash required: ignored)", type: json.class
            log.debug "broken content", content: json_string
            return
          end
          @store = json
        rescue => e
          log.error "failed to load data for plugin storage from redis", path: @path, error: e
        end
      end

      def save
        begin
          json_string = Yajl::Encoder.encode(@store)
          @redis.pipelined {
            @redis.set(@path, json_string)
          }
        rescue => e
          log.error "failed to save data for plugin storage to redis", path: @path, error: e
        end
      end

      def get(key)
        @store[key.to_s]
      end

      def fetch(key, defval)
        @store.fetch(key.to_s, defval)
      end

      def put(key, value)
        @store[key.to_s] = value
      end

      def delete(key)
        @store.delete(key.to_s)
      end

      def update(key, &block)
        @store[key.to_s] = block.call(@store[key.to_s])
      end
    end
  end
end
