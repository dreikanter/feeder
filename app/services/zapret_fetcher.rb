class ZapretFetcher
  URL = 'https://zapret.info/api/?url=%s'.freeze

  def self.call(value)
    response = RestClient.get(format(URL, CGI.escape(value)))
    !!JSON.parse(response.body)['isBlocked']
  end
end
