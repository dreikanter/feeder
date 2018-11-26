module Service
  class LoaderResolver
    extend Dry::Initializer

    param :feed

    DEFAULT_LOADER = 'http'.freeze

    def self.call(feed)
      new(feed).call
    end

    def call
      matching_loader || raise("no matching loader for '#{feed.name}'")
    end

    private

    def matching_loader
      available_names.each do |name|
        safe_name = name.to_s.gsub(/-/, '_')
        return "loaders/#{safe_name}_loader".classify.constantize
      rescue
        next
      end
    end

    def available_names
      [
        feed.loader,
        feed.name,
        DEFAULT_LOADER
      ]
    end
  end
end
