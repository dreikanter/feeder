# Generates daily digest for the past date:
# - Receives RSS feed content from HttpLoader
# - Filters posts for the past date
# - Fetches comments count for each post
# - Order posts by comments count
# - Generates one Entity with the list of post references
class KotakuDailyProcessor < BaseProcessor
  def call
    [yesterday_digest_entity]
  end

  private

  def yesterday_digest_entity
    entity("uid", {})
  end
end
