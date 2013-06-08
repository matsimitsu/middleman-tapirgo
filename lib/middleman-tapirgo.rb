require "middleman-core"
require "middleman-tapirgo/syncer"
require "middleman-tapirgo/syncable_item"

::Middleman::Extensions.register(:tapirgo) do
  require "middleman-tapirgo/extension"
  ::Middleman::Tapirgo
end
