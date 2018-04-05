module Normalizers
  class NewfluxNormalizer < Normalizers::FeedjiraNormalizer
    def comments
      [summary]
    end

    private

    def summary
      Service::Html.comment_excerpt(entity.summary)
    end
  end
end
