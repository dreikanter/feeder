Service::Feeds.index.each do |feed|
  Feed.find_or_create_by(name: feed.name).update(feed.to_h)
end
