class NitterInstancesFetcher
  include Callee

  PUBLIC_INSTANCES_WIKI_PAGE_URL = 'https://github.com/zedeus/nitter/wiki/Instances'.freeze
  WELL_KNOWN_INSTANCES = ['https://nitter.net'].freeze

  def call
    WELL_KNOWN_INSTANCES.dup.concat(public_instance_urls).uniq
  end

  private

  def public_instance_urls
    trs.filter_map { |tr| instance_url(tr) }
  end

  CHECKMARK = '✅'.freeze

  private_constant :CHECKMARK

  def instance_url(row)
    tds = row.css('td')
    return unless tds.count > 4 && tds[1].text.include?(CHECKMARK)
    tds.first.css('a').attribute('href').value
  end

  def trs
    Nokogiri::HTML(content).css('a#user-content-public,table>tbody>tr')
  end

  def content
    RestClient.get(PUBLIC_INSTANCES_WIKI_PAGE_URL).body
  end
end
