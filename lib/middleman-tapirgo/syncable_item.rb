module Middleman
  module Tapirgo

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
