class FreefeedClientBuilder
  include Callee

  def call
    Freefeed::Client.new(
      token: ENV['FREEFEED_TOKEN'] || Rails.application.credentials.freefeed_token,
      base_url: ENV['FREEFEED_BASE_URL'] || Rails.application.credentials.freefeed_base_url
    )
  end
end
