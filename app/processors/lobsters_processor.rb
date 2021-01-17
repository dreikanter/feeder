class LobstersProcessor < FeedjiraProcessor
  protected

  def entities
    parse_content.map { |entity| entity(entity.entry_id, entity) }
  end
end
