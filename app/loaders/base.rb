module Loaders
  class Base
    include Callee

    param :feed
    param :options, default: proc { {} }
  end
end
