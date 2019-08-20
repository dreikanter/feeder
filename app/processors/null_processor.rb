class NullProcessor < BaseProcessor
  protected

  NONE = [].freeze

  def entities
    NONE
  end
end
