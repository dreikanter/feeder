class FeedNames
  include Callee

  option :feeds_list, optional: true, default: -> { FeedsList }

  def call
    feeds_list.call.map(&:name)
  end
end
