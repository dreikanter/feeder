module Normalizers
  class ReworkNormalizer < Normalizers::Base
    protected

    # TODO: Link is not provided
    def link
      '-'
    end

    def published_at
      entity.pubDate
    end

    def text
      "#{entity.title}\n#{record_url} #{formatted_duration}".strip
    end

    def comments
      [description].reject(&:blank?)
    end

    private

    def description
      html = Nokogiri::HTML(entity.description)
      result = html.css('p').try(:first).try(:text).try(:squeeze)
      Service::Html.comment_excerpt(result)
    end

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
