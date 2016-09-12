module Processors
  class DilbertProcessor < Processors::AtomProcessor
    def published_at(item)
      DateTime.parse(link(item).split('/').last)
    rescue
      Rails.logger.error "error parsing date from url: #{link}"
      nil
    end
  end
end
