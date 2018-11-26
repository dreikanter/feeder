module Loaders
  class Base
    extend Dry::Initializer

    param :feed

    def self.call(feed)
      new(feed).call
    end

    def call
      raise NotImplementedError
    end
  end
end
