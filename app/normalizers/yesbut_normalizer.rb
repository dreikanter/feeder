class YesbutNormalizer < TwitterNormalizer
  def text
    [tweet_text, link].find { !_1.blank? }
  end
end
