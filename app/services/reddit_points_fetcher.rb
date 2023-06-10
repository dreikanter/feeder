class RedditPointsFetcher
  include Callee

  param :url

  def call
    Honeybadger.context(libreddit_host: libreddit_host, short_url: short_url, libreddit_url: libreddit_url)
    Integer(dom.css('.post_score').attribute('title').value)
  end

  private

  def dom
    Nokogiri::HTML(page_content)
  end

  # TODO: Replace with dynamically updated list
  # SEE: https://github.com/libreddit/libreddit-instances/blob/master/instances.md
  LIBREDDIT_HOSTS = %w[
    https://safereddit.com
    https://libreddit.kavin.rocks
    https://reddit.invak.id
    https://reddit.simo.sh
    https://lr.riverside.rocks
    https://libreddit.strongthany.cc
    https://libreddit.privacy.com.de
    https://reddit.baby
    https://libreddit.domain.glass
    https://r.nf
    https://lr.mint.lgbt
    https://libreddit.pussthecat.org
    https://libreddit.northboot.xyz
    https://libreddit.hu
    https://libreddit.totaldarkness.net
    https://lr.vern.cc
    https://libreddit.nl
    https://reddi.tk
    https://r.walkx.fyi
    https://libreddit.kylrth.com
    https://libreddit.tiekoetter.com
    https://reddit.rtrace.io
    https://libreddit.privacydev.net
    https://r.ahwx.org
    https://reddit.dr460nf1r3.org
    https://l.opnxng.com
    https://libreddit.cachyos.org
    https://rd.funami.tech
    https://libreddit.projectsegfau.lt
    https://lr.slipfox.xyz
    https://libreddit.oxymagnesium.com
    https://reddit.utsav2.dev
    https://libreddit.freedit.eu
    https://libreddit.mha.fi
    https://libreddit.garudalinux.org
    https://lr.4201337.xyz
    https://lr.odyssey346.dev
    https://lr.artemislena.eu
    https://discuss.whatever.social
    https://libreddit.pufe.org
    https://lr.aeong.one
    https://reddit.smnz.de
    https://reddit.leptons.xyz
    https://libreddit.lunar.icu
    https://reddit.moe.ngo
    https://r.darklab.sh
    https://snoo.habedieeh.re
    https://libreddit.kutay.dev
    https://libreddit.tux.pizza
  ].freeze

  private_constant :LIBREDDIT_HOSTS

  def page_content
    HTTP.get(libreddit_url).body.to_s
  end

  def libreddit_url
    URI.parse(short_url).tap { |parsed| parsed.host = libreddit_host }.to_s
  end

  def short_url
    RedditSlugsChopper.call(url)
  end

  def libreddit_host
    @libreddit_host ||= URI.parse(LIBREDDIT_HOSTS.sample).host
  end
end
