class AtomNormalizer < BaseNormalizer
  def link
    content.link.try(:href)
  end

  def published_at
    content.published.try(:content) || content.updated.try(:content)
  end

  def text
    content.title.try(:content)
  end
end
