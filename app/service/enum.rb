module Service
  class Enum
    def self.new(*args, **kwargs)
      Class.new do
        @enum = Hash[args.each_with_index.to_a].merge(kwargs || {}).freeze
        @enum.each { |key, value| define_singleton_method(key) { value } }
        define_singleton_method(:hash) { @enum }
        define_singleton_method(:keys) { @enum.keys }
        define_singleton_method(:values) { @enum.values }
      end
    end
  end
end
