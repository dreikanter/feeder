class PluralisticNoralizer < RssNormalizer
  def link
    nil
  end

  # @return [DateTime] (guaranteed) post creation timestamp with a fallsback
  #   to the current time
  # :reek:UtilityFunction
  def published_at
    DateTime.now
  end

  def text
    nil
  end

  def attachments
    []
  end

  def comments
    []
  end

  def separator
    SEPARATOR
  end

  def validation_errors
    @validation_errors ||= base_validation_errors
  end
end
