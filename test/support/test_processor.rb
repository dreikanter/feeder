class TestProcessor < BaseProcessor
  ENTITIES = [
    Entity.new(:uid0, :entity0),
    Entity.new(:uid1, :entity1),
    Entity.new(:uid2, :entity2)
  ].freeze

  protected

  def entities
    ENTITIES
  end
end
