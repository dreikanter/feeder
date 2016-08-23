module Freefeed
  class API
    BASE_URL = 'https://freefeed.net/v1/'

    def initialize(token)
      @token = token
    end

    def create_attachment_from_url(url)
      Tempfile.open([FEED, path_from_url(url)]) do |file|
        file.binmode
        re = RestClient.get(url)
        file.write(re.body)
        file.rewind
        execute(:post, :attachments, payload: {
          'miltipart' => true,
          'file' => file
        }, headers: {
          'Content-Type' => re.headers[:content_type]
        })
      end
    end

    def create_attachment_from_file(file)
      execute(:post, :attachments, payload: {
        'miltipart' => true,
        'file' => file
      })
    end

    def create_post(body, options = {})
      execute(:post, :posts, payload: {
        'post' => {
          'body' => body,
          'attachments' => options[:attachments] || []
        },
        'meta' => {
          'feeds' => options[:feeds]
        }
      })
    end

    def post(id)
      execute(:get, "posts/#{id}", payload: { 'maxComments' => 0 })
    end

    def create_comment(post_id, body)
      execute(:post, 'comments', payload: {
        'comment' => {
          'body' => body,
          'postId' => post_id
        }
      })
    end

    private

    def token
      @token
    end

    def url(path)
      BASE_URL + path.to_s
    end

    def auth_header
      { 'X-Authentication-Token' => token }
    end

    def execute(method, path, options = {})
      process_response RestClient::Request.execute(
        method: method,
        url: url(path),
        payload: options[:payload],
        headers: (options[:headers] || {}).merge(auth_header)
      )
    end

    def process_response(response)
      return JSON.parse(response.body) if response.code == 200
      raise "response code: #{response.code}"
    end

    def path_from_url(url)
      File.basename(URI.parse(url).path)
    end
  end
end
