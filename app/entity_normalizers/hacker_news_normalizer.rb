module EntityNormalizers
  class HackerNewsNormalizer < EntityNormalizers::RssNormalizer
    def text
      [super, link].join(separator)
    end

    def comments
      [ "Comments: #{entity.comments}" ]
    end
  end
end
