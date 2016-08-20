require 'rss'
require 'open-uri'

class XkcdFeed
  FEED_URL = 'http://xkcd.com/rss.xml'

  def self.recent
    new.recent
  end

  def recent
    RSS::Parser.parse(open(FEED_URL)).items.map { |item| attrs(item) }
  end

  private

  def attrs(item)
    item_attrs(item).merge(image_attrs(first_img_tag(item.description)))
  end

  def item_attrs(item)
    {
      title: item.title,
      link: item.link
    }
  end

  def image_attrs(image)
    {
      content: image['alt'] || '',
      image_url: image['src']
    }
  end

  def first_img_tag(html)
    Nokogiri::HTML(html).css('img').first
  end
end
