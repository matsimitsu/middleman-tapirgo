module Middleman
  module Tapirgo


    class Syncer

      def inst
        ::Middleman::Application.server.inst
      end

      def options
        Middleman::Tapirgo.options
      end

      def uri
        URI("http://tapirgo.com/api/1/push_article.json?secret=#{options.api_key}")
      end

      def sync
        return unless options.api_key

        syncable_items = inst.sitemap.resources.select { |r| r.ext == '.html' }

        syncable_items.each do |r|
          syncable_item = Middleman::Tapirgo::SyncableItem.new(r)
          response = send_to_tapirgo(syncable_item)
          if response.code != '200'
            puts "Failed sending #{syncable_item.link} to TapirGo"
            puts "Response #{response.code} #{response.message}"
            break
          end
        end
        puts "Synced #{syncable_items.length} to TapirGo"
      end

      def send_to_tapirgo(item)
        req = Net::HTTP::Post.new(uri.path, initheader = {'Content-Type' =>'application/json'})
        req.body = JSON.generate(item)
        Net::HTTP.new(uri.host, uri.port).start {|http| http.request(req) }
      end
    end

    class SyncableItem

      def initialize(resource)
        @resource = resource
      end

      def content
        @resource.render(:layout => nil)
      end

      def published_on
        Time.parse(@resource.data['date'])
      rescue
        File.mtime(@resource.source_file)
      end

      def title
        @resource.data['title'] || @resource.path
      end

      def link
        @resource.path
      end

      def to_hash
        {
          :title => title,
          :content => content,
          :link => link,
          :published_on => published_on
        }
      end
    end
  end
end
