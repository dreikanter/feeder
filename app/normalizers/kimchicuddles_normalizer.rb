module Normalizers
  class KimchicuddlesNormalizer < Normalizers::Base
    def text
      entity.url
    end

    def link
      entity.url
    end

    def published_at
      entity.published
    end

    def attachments
      [get_high_res_image_url]
    end

    def comments
      [description]
    end

    private

    def get_high_res_image_url
      url = image_url.to_s.gsub(/_500\.jpg$/, '_1280.jpg')
      response = RestClient.head(url)
      (response.code == 200) ? url : image_url
    rescue
      image_url
    end

    def image_url
      Service::Html.first_image_url(entity.summary)
    end

    def description
      result = Service::Html.comment_excerpt(entity.summary)
      result.to_s.gsub(/\n+/, "\n")
    end
  end
end
