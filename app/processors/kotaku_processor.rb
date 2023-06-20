class KotakuProcessor < BaseProcessor
  protected

  def entities
    content.map { |rss_entry| entity(rss_entry.url, rss_entry) }
  end
end
