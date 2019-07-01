module Service
  class DnsRecordsFetcher
    def self.call(domain)
      records = Resolv::DNS.open do |dns|
        dns.getresources(domain, Resolv::DNS::Resource::IN::A)
      end

      records.map { |record| record.address.to_s }
    rescue
      raise "error fetching DNS records for '#{domain}'"
    end
  end
end
