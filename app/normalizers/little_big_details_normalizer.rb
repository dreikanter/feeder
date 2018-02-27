module Normalizers
  class LittleBigDetailsNormalizer < Normalizers::TumblrNormalizer
    def text
      [description, link].join(separator)
    end

    private

    def description
      Service::Html.text(entity.description)
    end
  end
end
