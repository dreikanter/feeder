class LobstersProcessor < FeedjiraProcessor
  protected

  def entities
    parse_content.map { entity(_1.entry_id, _1) }
  end
end
