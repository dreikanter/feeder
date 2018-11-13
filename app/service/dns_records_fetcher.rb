module Service
  class DnsRecordsFetcher
    def self.call(domain)
      response = RestClient.get("https://dns-api.org/A/#{domain}")
      JSON.parse(response.body)
    rescue
      raise "error fetching DNS records for '#{domain}'"
    end
  end
end
