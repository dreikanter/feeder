Feed.all.each do |feed|
  value = feed.posts.maximum(:created_at)
  feed.update(last_post_created_at: value)
end
