class DnsRecordsFetcher
  def self.call(domain)
    records = Resolv::DNS.open do |dns|
      dns.getresources(domain, Resolv::DNS::Resource::IN::A)
    end

    records.map { |record| record.address.to_s }
  rescue => e
    raise "error fetching DNS records for '#{domain}': #{e.message}"
  end
end
