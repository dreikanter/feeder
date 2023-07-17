class FreefeedClientBuilder
  class << self
    # :reek:UtilityFunction
    def call
      Freefeed::Client.new(
        token: ENV.fetch("FREEFEED_TOKEN"),
        base_url: base_url
      )
    end

    # TODO: Extract this configuration accessor
    def base_url
      ENV.fetch("FREEFEED_BASE_URL")
    end
  end
end
