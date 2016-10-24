module EntityNormalizers
  class HackerNewsNormalizer < EntityNormalizers::Base
    def text
      [entity[:text], link].join(separator)
    end

    def link
      entity[:url]
    end

    def comments
      [[entity[:score], entity[:thread_url]].reject(&:blank?).join(' / ')]
    end

    def published_at
      Time.zone.now
    end
  end
end
