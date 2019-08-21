# TODO: Refactor and move to a gem
module Freefeed
  class Client
    USER_AGENT = 'Mozilla'.freeze
    DEFAULT_API_VERSION = 1

    def initialize(token)
      @token = token
    end

    DEFAULT_SCHEME = 'http'.freeze

    def create_attachment_from_url(url)
      Rails.logger.info("create new attachment for #{url}")
      Tempfile.open(['feeder', path_from_url(url)]) do |file|
        file.binmode
        safe_url = Addressable::URI.parse(Addressable::URI.encode(url))
        safe_url.scheme ||= DEFAULT_SCHEME
        # NOTE: User agent here is a workaround for PhD Comics "protection"
        re = RestClient.get(safe_url.to_s, user_agent: USER_AGENT)
        file.write(re.body)
        file.rewind
        response = execute(:post, :attachments, payload: {
          'miltipart' => true,
          'file' => file
        }, headers: {
          'Content-Type' => re.headers[:content_type]
        })
        response.dig('attachments', 'id')
      end
    end

    def create_attachment_from_file(file)
      Rails.logger.info('create attachment from file')
      execute(:post, :attachments, payload: {
        'miltipart' => true,
        'file' => file
      })
    end

    def create_post(body, options = {})
      Rails.logger.info('create new post')
      response = execute(:post, :posts, payload: {
        'post' => post_payload(body, options),
        'meta' => {
          'feeds' => options[:feeds]
        }
      })
      response.dig('posts', 'id')
    end

    def post(id)
      execute(:get, "posts/#{id}", payload: { 'maxComments' => 0 })
    end

    def create_comment(post_id, body)
      Rails.logger.info('create comment')
      Rails.logger.info execute(:post, 'comments', payload: {
        'comment' => {
          'body' => body,
          'postId' => post_id
        }
      })
    end

    def get_timeline(username, options = {})
      Rails.logger.info('fetch timeline')
      offset = options[:offset] || 0

      execute(
        :get,
        "timelines/#{username}",
        payload: { 'offset' => offset },
        version: 2
      )
    end

    private

    def token
      @token
    end

    def url(path, options = {})
      version = options[:version] || DEFAULT_API_VERSION
      "#{Rails.application.credentials.freefeed_base_url}/v#{version}/#{path}"
    end

    def auth_header
      { 'X-Authentication-Token' => token }
    end

    def execute(method, path, options = {})
      request_params = {
        method: method,
        url: url(path, version: options[:version]),
        payload: options[:payload],
        headers: (options[:headers] || {}).merge(auth_header)
      }

      # Rails.logger.debug('---> HTTP request')
      # Rails.logger.debug(JSON.pretty_generate(request_params))

      result = JSON.parse(RestClient::Request.execute(**request_params).body)

      # Rails.logger.debug('---> HTTP response')
      # Rails.logger.debug(JSON.pretty_generate(result))

      result
    rescue RestClient::Exception => e
      Rails.logger.error '---> HTTP call error'
      Rails.logger.error JSON.pretty_generate(e.response.headers)
      Rails.logger.error e.response.body
      raise
    end

    def path_from_url(url)
      File.basename(Addressable::URI.parse(url).path)
    end

    def post_payload(body, options)
      attachments = options[:attachments]
      return { 'body' => body } if attachments.blank?
      { 'body' => body, 'attachments' => attachments }
    end
  end
end
