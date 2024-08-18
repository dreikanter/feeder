# Data object for raw feed content representation. All loaders return
# a FeedContent instance.
#
# @see BaseLoader
#
class FeedContent
  attr_reader :raw_content, :imported_at, :import_duration

  def initialize(raw_content:, imported_at:, import_duration:)
    @raw_content = raw_content
    @imported_at = imported_at
    @import_duration = import_duration
  end
end
