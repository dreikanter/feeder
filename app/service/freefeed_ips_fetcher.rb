module Service
  class FreefeedIpsFetcher
    DOMAINS = ['freefeed.net', 'media.freefeed.net']

    def self.call
      records = []

      DOMAINS.each do |domain|
        records += Service::DnsRecordsFetcher.call(domain)
      end

      records.map { |record| record['value'] }.uniq
    end
  end
end
