require "rails_helper"

RSpec.describe EntityTest do
  subject(:model) { described_class }

  it "initializes attributes" do
    entity = Entity.new(uid: "uid", content: "content", feed: "feed")
    assert_equal("uid", entity.uid)
    assert_equal("content", entity.content)
    assert_equal("feed", entity.feed)
  end
end
