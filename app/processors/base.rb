module Processors
  class Base
    def self.process(source)
      send(:new, source).send(:process)
    end

    attr_reader :source

    private

    def initialize(source)
      @source = source
    end

    def process
      items.map { |item| process_item(item) }
    end

    def items
      fail NotImplementedError, "#{self.class.name}##{__method__} is not implemented"
    end

    ATTRIBUTES = %w(link published_at text attachments comments)

    def process_item(item)
      ATTRIBUTES.map { |a| [a, send(a, item)] }.to_h
    end

    def link(item)
      nil
    end

    def published_at(item)
      nil
    end

    def text(item)
      nil
    end

    def attachments(item)
      []
    end

    def comments(item)
      []
    end
  end
end
