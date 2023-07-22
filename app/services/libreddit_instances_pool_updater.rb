class LibredditInstancesPoolUpdater < ServiceInstancesPoolUpdater
  private

  def service_type
    "libreddit"
  end

  def availability_checker
    LibredditInstanceAvailabilityChecker
  end

  def instances_fetcher
    LibredditInstancesFetcher
  end
end
