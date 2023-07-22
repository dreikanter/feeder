class NitterProcessor < FeedjiraProcessor
  def entities
    parse_content.map { build_entity(NitterPermalink.call(_1.url), _1) }
  end
end
