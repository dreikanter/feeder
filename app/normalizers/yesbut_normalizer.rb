class YesbutNormalizer < TwitterNormalizer
  def text
    [tweet_text, link].find(&:present?).to_s
  end
end
