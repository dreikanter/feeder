require_relative '../../app/service/feeds_list.rb'

namespace :pull do
  Service::FeedsList.names.each do |name|
    desc "Pull #{name} feed"
    task name => :environment do
      PullJob.perform_later(name)
    end
  end

  desc 'Pull all feeds'
  task all: :environment do
    Service::FeedsList.names.each do |name|
      PullJob.perform_later(name)
    end
  end
end
