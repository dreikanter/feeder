class AtomNormalizer < BaseNormalizer
  def link
    content.link.try(:href)
  end

  def published_at
    content.published.try(:content) || content.updated.try(:content)
  end

  def text
    title = content.title.try(:content)
    title && CGI.unescapeHTML(title)
  end
end
