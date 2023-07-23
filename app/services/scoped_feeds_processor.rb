class ScopedFeedsProcessor
  attr_reader :feeds_scope

  def self.process
    FeedsConfiguration.sync
    new(yield).process
  end

  def initialize(feeds_scope)
    @feeds_scope = feeds_scope
  end

  def process
    feeds_scope.each { PublicationQueueProcessor.new(_1).process_queue }
  end
end
