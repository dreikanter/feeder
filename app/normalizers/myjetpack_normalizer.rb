module Normalizers
  class MyjetpackNormalizer < Normalizers::TumblrNormalizer
    def text
      [Service::Html.text(entity.description), link].join(separator)
    end
  end
end
