namespace :feeder do
  desc 'Load test data for each feed'
  task load_test_data: :environment do
    FeedsNames.call.each do |feed|
      path = "test/data/feed_#{feed.name}.xml"
      File.open(path, 'wt') do |f|
        puts "Saving #{feed.url}\nto #{path}\n\n"
        f.write RestClient.get(url)
      end
    end
  end
end
