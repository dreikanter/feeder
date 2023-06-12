require "test_helper"

class EntityTest < Minitest::Test
  def subject
    Entity
  end

  def test_initializer
    entity = Entity.new(uid: "uid", content: "content", feed: "feed")
    assert_equal("uid", entity.uid)
    assert_equal("content", entity.content)
    assert_equal("feed", entity.feed)
  end
end
