class FreefeedIpsFetcher
  DOMAIN = "freefeed.net".freeze

  def self.call(fetcher: DnsRecordsFetcher, domain: DOMAIN)
    fetcher.call(domain).uniq
  end
end
