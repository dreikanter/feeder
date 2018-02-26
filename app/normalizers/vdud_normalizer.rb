module Normalizers
  class VdudNormalizer < Normalizers::YoutubeNormalizer
    def text
      title = entity.title.gsub(/\s+\/\s+вДудь\Z/, '')
      [title, entity.url].join(separator)
    end
  end
end
