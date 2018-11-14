module Service
  class FreefeedIpsFetcher
    DOMAIN = 'freefeed.net'.freeze

    def self.call(fetcher: Service::DnsRecordsFetcher, domain: DOMAIN)
      records = fetcher.call(domain)
      records.map { |record| record['value'] }.uniq
    end
  end
end
