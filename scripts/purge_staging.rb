# Use Rails runner to execute this script:
#
#   rails r scripts/purge_staging.rb

# NOTE: Freefeed base URL is intentionally hardcoded since this script
# is designed to be used with staging server only

USER = 'feeder'.freeze

posts_count = 0

loop do
  puts 'loading posts'

  result = RestClient::Request.execute(
    method: :get,
    url: 'https://candy.freefeed.net/v2/timelines/home?offset=0',
    headers: {
      'X-Authentication-Token' => Rails.application.credentials.freefeed_token
    }
  )

  data = JSON.parse(result.body)
  posts = data['posts']
  users = data['users']
  user_id = users.find { |user| user['username'] == USER }['id']
  own_posts = posts.select { |post| post['createdBy'] == user_id }

  unless own_posts.any?
    puts "#{posts_count} deleted"
    exit
  end

  puts "#{own_posts.length} posts loaded"


  own_posts.each do |post|
    post_id = post['id']
    puts "deleting #{post_id}"

    RestClient::Request.execute(
      method: :delete,
      url: "https://candy.freefeed.net/v1/posts/#{post_id}",
      headers: {
        'X-Authentication-Token' => Rails.application.credentials.freefeed_token
      }
    )

    posts_count += 1
  end
end
