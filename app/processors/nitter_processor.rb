class NitterProcessor < FeedjiraProcessor
  protected

  def entity(uid, entity_content)
    super(NitterPermalink.call(uid), entity_content)
  end
end
