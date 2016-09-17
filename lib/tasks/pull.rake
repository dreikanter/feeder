require_relative '../../app/service/feeds.rb'

namespace :pull do
  Service::Feeds.index.map(&:name).each do |name|
    desc "Pull #{name} feed"
    task name => :environment do
      PullJob.perform_later(name)
    end
  end

  desc 'Pull all feeds'
  task all: :environment do
    Service::Feeds.index.map(&:name).each do |name|
      PullJob.perform_later name.to_s
    end
  end
end
