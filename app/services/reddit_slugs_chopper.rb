class RedditSlugsChopper
  include Callee

  param :url

  def call
    Addressable::URI.parse(url).tap { |parsed| parsed.path = short_path(parsed.path) }.to_s
  end

  private

  def short_path(path)
    path.gsub(%r{[^/]*/$}, '')
  end
end
