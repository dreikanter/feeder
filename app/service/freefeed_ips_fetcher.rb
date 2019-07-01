module Service
  class FreefeedIpsFetcher
    DOMAIN = 'freefeed.net'.freeze

    def self.call(fetcher: Service::DnsRecordsFetcher, domain: DOMAIN)
      fetcher.call(domain).uniq
    end
  end
end
