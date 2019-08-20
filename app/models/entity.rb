class Entity
  attr_reader :uid
  attr_reader :content

  def initialize(uid, content)
    @uid = uid
    @content = content
  end
end
