# Use Rails runner to execute this script:
#
#   rails r scripts/purge_staging.rb

posts_count = 0

loop do
  puts "---> loading posts"

  result = RestClient::Request.execute(
    method: :get,
    url: 'https://candy.freefeed.net/v2/timelines/feeder?offset=0',
    headers: {
      'X-Authentication-Token' => ENV.fetch('FREEFEED_TOKEN')
    }
  )

  posts = JSON.parse(result.body)['posts']

  unless posts.present? && posts.any?
    puts "#{posts_count} deleted"
    exit
  end

  puts "---> #{posts.length} posts loaded"

  posts.each do |post|
    post_id = post['id']
    puts "deleting #{post_id}"

    RestClient::Request.execute(
      method: :delete,
      url: "https://candy.freefeed.net/v1/posts/#{post_id}",
      headers: {
        'X-Authentication-Token' => ENV.fetch('FREEFEED_TOKEN')
      }
    )

    posts_count += 1
  end
end
