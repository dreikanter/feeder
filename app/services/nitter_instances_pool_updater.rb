class NitterInstancesPoolUpdater
  include Callee

  def call
    remove_delisted_instances
    import_listed_instances
  end

  private

  def import_listed_instances
    instance_urls.each do |instance_url|
      NitterInstance.find_or_create_by(url: instance_url)
    end
  end

  def remove_delisted_instances
    delisted_instances.update_all(status: :removed)
  end

  def delisted_instances
    NitterInstance.where.not(url: instance_urls)
  end

  def instance_urls
    @instance_urls ||= NitterInstancesFetcher.call
  end
end
