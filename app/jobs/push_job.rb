class PushJob < ApplicationJob
  queue_as :default

  def perform(post)
    Push.call(post)
  end
end
