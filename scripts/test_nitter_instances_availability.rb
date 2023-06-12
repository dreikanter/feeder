# Usage: rails r scripts/test_nitter_instances_availability.rb

puts "Available Nitter instances:\n\n"

NitterInstancesFetcher.call.each do |url|
  rss_url = URI.parse(url).merge("/_yesbut_/rss").to_s

  begin
    RestClient.get(rss_url).body
    puts url
  rescue StandardError
    # ignore if not available
  end
end
