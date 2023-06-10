# Usage: rails r scripts/test_nitter_instances_availability.rb

puts "Available libreddit instances:\n\n"

INSTANCES = %w[
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
  https://libreddit.de
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
  https://libreddit.dcs0.hu
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
  https://libreddit.bus-hit.me
  https://reddit.leptons.xyz
  https://libreddit.lunar.icu
  https://reddit.moe.ngo
  https://r.darklab.sh
  https://snoo.habedieeh.re
  https://libreddit.kutay.dev
  https://libreddit.tux.pizza
].freeze

INSTANCES.each do |url|
  rss_url = URI.parse(url).merge('/r/worldnews').to_s

  begin
    RestClient.get(rss_url).body
    puts url
  rescue StandardError
    # ignore if not available
  end
end
