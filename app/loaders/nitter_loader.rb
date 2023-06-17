class NitterLoader < BaseLoader
  # TODO: Replace with dynamically updated list
  # SEE: https://github.com/zedeus/nitter/wiki/Instances
  NITTER_INSTANCES = %w[
    https://nitter.net
    https://nitter.lacontrevoie.fr
    https://nitter.fdn.fr
    https://nitter.1d4.us
    https://nitter.moomoo.me
    https://nitter.it
    https://twitter.owacon.moe
    https://nitter.fly.dev
    https://notabird.site
    https://nitter.sethforprivacy.com
    https://nitter.cutelab.space
    https://nitter.mint.lgbt
    https://nitter.esmailelbob.xyz
    https://tw.artemislena.eu
    https://nitter.privacy.com.de
    https://nitter.bird.froth.zone
    https://twitter.dr460nf1r3.org
    https://nitter.cz
    https://tweet.lambda.dance
    https://nitter.kylrth.com
    https://unofficialbird.com
    https://nitter.projectsegfau.lt
    https://nitter.eu.projectsegfau.lt
    https://singapore.unofficialbird.com
    https://canada.unofficialbird.com
    https://india.unofficialbird.com
    https://nederland.unofficialbird.com
    https://uk.unofficialbird.com
    https://read.whatever.social
    https://nitter.rawbit.ninja
    https://nitter.sneed.network
    https://n.sneed.network
    https://nitter.twei.space
    https://nitter.inpt.fr
    https://nitter.d420.de
    https://nitter.caioalonso.com
    https://nitter.nicfab.eu
    https://bird.habedieeh.re
    https://nitter.hostux.net
    https://nitter.adminforge.de
    https://nitter.pufe.org
    https://nitter.us.projectsegfau.lt
    https://nitter.arcticfoxes.net
    https://t.com.sb
    https://nitter.kling.gg
    https://nitter.ktachibana.party
    https://ntr.odyssey346.dev
    https://nitter.lunar.icu
    https://twitter.moe.ngo
    https://nitter.freedit.eu
    https://n.opnxng.com
    https://nitter.in.projectsegfau.lt
    https://nitter.tux.pizza
    https://t.floss.media
    https://n.quadtr.ee
    https://nitter.one
    https://nitter.io.lol
    https://nitter.no-logs.com
    https://nitter.fascinated.cc
    https://t.uchun.net
    https://nitter.fediflix.org
    https://nitter.services.woodland.cafe
  ].freeze

  option(:nitter_url, optional: true, default: -> { NITTER_INSTANCES.sample })

  protected

  def perform
    RestClient.get(nitter_rss_url.to_s).body
  rescue StandardError => e
    # TODO: Do not treat 404 as instance availability
    ErrorDumper.call(exception: e, message: "Nitter error", target: feed)
    register_nitter_instance_error
    raise
  end

  private

  def register_nitter_instance_error
    NitterInstance.find_or_create_by(url: nitter_url).error!
  end

  def nitter_rss_url
    URI.parse(nitter_url).merge("/#{twitter_user}/rss")
  end

  def twitter_user
    feed.options.fetch("twitter_user")
  end
end
