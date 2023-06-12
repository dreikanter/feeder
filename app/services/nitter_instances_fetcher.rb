class NitterInstancesFetcher
  include Callee

  PUBLIC_INSTANCES_WIKI_PAGE_URL = "https://github.com/zedeus/nitter/wiki/Instances".freeze
  WELL_KNOWN_INSTANCES = ["https://nitter.net"].freeze

  def call
    WELL_KNOWN_INSTANCES.dup.concat(public_instance_urls).uniq
  end

  private

  def public_instance_urls
    rows.map { |row| instance_url(row) }.compact
  end

  CHECKMARK = "✅".freeze

  private_constant :CHECKMARK

  # WARNING: Parsing non-semantic markup, magic-magic-magic
  def instance_url(row)
    cells = row.css("td")
    return unless cells.count > 4 && cells[1].text.include?(CHECKMARK)
    cells.first.css("a").attribute("href").value
  end

  def rows
    Nokogiri::HTML(content).css("a#user-content-public,table>tbody>tr")
  end

  def content
    RestClient.get(PUBLIC_INSTANCES_WIKI_PAGE_URL).body
  end
end
