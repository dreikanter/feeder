module Normalizers
  class BazarNormalizer < Normalizers::Base
    def link
      entity.link
    end

    def published_at
      entity.pubDate
    end

    def text
      result = [entity.title, link].join(separator)
      return result unless record_url.present?
      "#{result}\n\nЗапись: #{record_url} #{formatted_duration}".strip
    end

    def comments
      [entity.description].reject(&:blank?)
    end

    private

    def record_url
      @record_url ||= entity.try(:enclosure).try(:url)
    end

    def formatted_duration
      return nil unless duration
      "(#{duration})"
    end

    def duration
      @duration ||= entity.try(:itunes_duration).try(:content).gsub(/^00:/, '')
    end
  end
end
