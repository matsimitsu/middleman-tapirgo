module Middleman
  module Tapirgo

    class Syncer

      attr_reader :options
      def initialize(options={})
        @options = options
      end

      def inst
        ::Middleman::Application.server.inst
      end

      def uri
        URI("http://tapirgo.com/api/1/push_article.json?secret=#{options[:api_key]}")
      end

      def syncable_items
        @syncable_items ||= inst.sitemap.resources.select { |r| r.ext == '.html' }
      end

      def sync
        return unless options[:api_key]

        syncable_items.each do |r|
          syncable_item = Middleman::Tapirgo::SyncableItem.new(r)
          response = send_to_tapirgo(syncable_item)
          if response.code != '200'
            puts "Failed sending #{syncable_item.link} to TapirGo"
            puts "Response #{response.code} #{response.message}"
            break
          end
        end
        puts "Synced #{syncable_items.length} items to TapirGo"
      end

      def send_to_tapirgo(item)
        req = Net::HTTP::Post.new("#{uri.path}?#{uri.query}", initheader = {'Content-Type' =>'application/json'})
        req.body = JSON.generate(item)
        Net::HTTP.new(uri.host, uri.port).start {|http| http.request(req) }
      end
    end

  end
end
