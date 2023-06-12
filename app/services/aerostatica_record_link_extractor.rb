class AerostaticaRecordLinkExtractor
  PATTERN = %r{https://aerostatica\.ru/music/\w+\.mp3}

  def self.call(content)
    content.scan(PATTERN).first
  end
end
