module Loaders
  class Base
    extend Dry::Initializer

    param :feed
    param :options, default: proc { {} }

    def self.call(feed, options = {})
      new(entity, options).call
    end

    def call
      raise NotImplementedError
    end
  end
end
