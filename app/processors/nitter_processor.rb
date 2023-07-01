class NitterProcessor < FeedjiraProcessor
  protected

  def build_entity(uid, entity_content)
    super(NitterPermalink.call(uid), entity_content)
  end
end
