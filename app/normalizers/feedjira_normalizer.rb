class FeedjiraNormalizer < BaseNormalizer
  protected

  def link
    content.url
  end

  def published_at
    content.published
  end

  def text
    [content.title, content.url].join(separator)
  end

  def comments
    binding.pry
    [content.content]
  end

  # NOTE: Do't publish anything doring experimental stage
  def validation_errors
    ["experimental"]
  end
end
