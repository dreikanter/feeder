class LobstersProcessor < FeedjiraProcessor
  def process
    parse_content.map { build_entity(_1.entry_id, _1) }
  end
end
