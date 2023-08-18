class FeedjiraProcessor < BaseProcessor
  def process
    parse_content.map do |entity|
      build_post(
        uid: entity.url,
        source_content: entity.to_h.as_json,
        published_at: Time.current
      )
    end
  end

  private

  def parse_content
    Feedjira.parse(content).entries
  end
end
