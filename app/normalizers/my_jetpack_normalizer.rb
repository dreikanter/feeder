module Normalizers
  class MyJetpackNormalizer < Normalizers::TumblrNormalizer
    protected

    def text
      [Service::Html.text(entity.description), link].join(separator)
    end
  end
end
