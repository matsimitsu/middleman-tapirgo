require "middleman-core"
require "middleman-tapirgo/syncer"

::Middleman::Extensions.register(:tapirgo) do
  require "middleman-tapirgo/extension"
  ::Middleman::Tapirgo
end
