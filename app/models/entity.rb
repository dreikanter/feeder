class Entity
  attr_reader :uid, :content

  def initialize(uid, content)
    @uid = uid
    @content = content
  end
end
