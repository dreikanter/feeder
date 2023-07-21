class ScopedFeedsImporter
  include Logging

  def import_each
    log_info("updating feeds configuration")
    FeedsConfiguration.sync
    scope = yield
    log_info("importing #{scope.count} feed(s): #{scope.pluck(:name).join(", ")}")
    scope.each { FeedImporter.new(_1).import }
  end
end
