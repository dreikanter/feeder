require_relative '../../app/const/feeds.rb'

namespace :pull do
  Const::Feeds::URLS.keys.each do |name|
    desc "Pull #{name} feed"
    task name => :environment do
      PullJob.perform_later(name)
    end
  end

  desc 'Pull all feeds'
  task all: :environment do
    Const::Feeds::URLS.keys.each { |name| PullJob.perform_later(name.to_s) }
  end
end
