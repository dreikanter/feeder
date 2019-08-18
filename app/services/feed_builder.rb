# Returns Feed entity mathing specified name, after making sure the feed
# exists and up to date with the configuration. Raise an error if the feed
# name is not recognized.
#
class FeedBuilder
  include Callee

  param :feed_name
  option :feeds_list, optional: true, default: -> { FeedsList.call }

  def call
    feeds_list.find_by!(name: feed_name)
  rescue ActiveRecord::RecordNotFound
    raise 'feed not exists'
  end
end
