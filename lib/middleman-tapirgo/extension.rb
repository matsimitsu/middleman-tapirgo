# Require core library
require "middleman-core"

# Extension namespace
module Middleman
  module Tapirgo

    class Options < Struct.new(:api_key); end

    class << self

      def options
        @@options
      end

      def registered(app, options_hash={}, &block)
        options = Options.new(options_hash)
        yield options if block_given?

        options.api_key ||= nil

        app.after_build do |builder|
          ::Middleman::Tapirgo::Syncer.new(options).sync
        end

        @@options = options

        app.send :include, Helpers
      end

      alias :included :registered

    end

    module Helpers
      def options
        ::Middleman::Tapirgo.options
      end
    end

  end
end
