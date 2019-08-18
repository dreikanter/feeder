class InstagramLoader < HttpLoader
  SCRIPT_PATH = Rails.root.join('scripts', 'ig.js').freeze

  option :script_path, optional: true, default: -> { SCRIPT_PATH }

  protected

  # TODO: Move script interaction to a service class
  def perform
    output = `node #{script_path} user #{instagram_user}`
    JSON.parse(output)
  end

  def instagram_user
    feed.options.fetch('instagram_user')
  rescue KeyError
    raise 'instagram feed is missing "instagram_user" option'
  end
end
