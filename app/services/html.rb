# frozen_string_literal: true

class Html
  MAX_POST_LENGTH = 1500
  MAX_COMMENT_LENGTH = 1500
  OMISSION = '... (continued)'

  EXCERPT_DEFAULTS = {
    length: 0,
    omission: OMISSION,
    separator: ' '
  }.freeze

  POST_EXCERPT_DEFAULTS = {
    length: MAX_POST_LENGTH,
    omission: OMISSION,
    link: '',
    separator: ''
  }.freeze

  HASHTAG_PATTERN = /(?:\s*|^)#[[:graph:]]+/.freeze

  EMOJI_CHARS = [
    ['\u{1f600}', '\u{1f64f}'],
    ['\u{2702}',  '\u{27b0}'],
    ['\u{1f680}', '\u{1f6ff}'],
    ['\u{24C2}',  '\u{1F251}'],
    ['\u{1f300}', '\u{1f5ff}']
  ].freeze

  EMOJI_PATTERN =
    Regexp.new(EMOJI_CHARS.map { |chars| chars.join('-') }.join).freeze

  def self.text(html)
    result = Nokogiri::HTML(html)
    result.css('br').each { |br| br.replace "\n" }
    squeeze(result.text)
  end

  def self.excerpt(html, options = {})
    opts = EXCERPT_DEFAULTS.merge(options)
    text(html).truncate(
      opts[:length],
      separator: opts[:separator],
      omission: opts[:omission]
    )
  end

  def self.post_excerpt(html, options = {})
    opts = POST_EXCERPT_DEFAULTS.merge(options)
    limit = opts[:length] - opts[:link].length - opts[:separator].length
    result = excerpt(html, length: limit, omission: opts[:omission])
    [result, opts[:link]].compact_blank.join(opts[:separator])
  end

  def self.squeeze(text)
    text.squeeze(' ').gsub(/[ \n]{2,}/, "\n\n").strip
  end

  def self.comment_excerpt(html)
    excerpt(html, length: MAX_COMMENT_LENGTH)
  end

  def self.image_urls(html, selector: nil, attribute: 'src')
    Nokogiri::HTML(html).css(selector || 'img').pluck(attribute)
  end

  def self.first_image_url(html, selector: nil)
    image_urls(html, selector: selector).first
  end

  def self.link_urls(html, selector: nil)
    Nokogiri::HTML(html).css(selector || 'a').pluck('href')
  end

  # rubocop:disable Metrics/CyclomaticComplexity, Metrics/AbcSize
  def self.paragraphs(html)
    result = Nokogiri::HTML(html)

    # Replace paragraphs with line breaks
    result.css('br,p,header,figure').each { |e| e.after "\n" }

    # Drop images
    result.css('img,figure').each(&:remove)

    result.css('a').each do |e|
      href = e['href']

      # Replace linked URLs with plain text URLs
      e.replace(href) if href.start_with?(e.content.sub(/…$/, ''))

      # Unlink hashtags
      e.replace(e.content) if e.content =~ HASHTAG_PATTERN
    end

    # rubocop:disable Style/CombinableLoops
    # Replace links with plain text URLs
    result.css('a').each { |e| e.after(" (#{e['href']})") }
    # rubocop:enable Style/CombinableLoops

    result.text.split(/\n/).compact_blank
  end
  # rubocop:enable Metrics/CyclomaticComplexity, Metrics/AbcSize

  def self.strip_emoji(text)
    text.force_encoding('utf-8').encode.gsub(EMOJI_PATTERN, '')
  end
end
