# SEE: https://stackoverflow.com/questions/16832963/what-is-the-url-schema-of-tumblr-images

class TumblrImageFetcher
  HIGH_RES_SUFFIX = '_1280.jpg'.freeze

  def self.call(url)
    return url if !url || url.end_with?(HIGH_RES_SUFFIX)

    high_res_url = url.to_s.gsub(/_\d+\.jpg$/, HIGH_RES_SUFFIX)

    begin
      Rails.logger.debug('trying to fetch high-res image url from tumblr')
      response = RestClient.head(high_res_url)
      return high_res_url if response.code == 200
    rescue StandardError
      Rails.logger.warn('error fetching image from tumblr')
    end

    url
  end
end
