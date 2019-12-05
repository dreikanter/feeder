class FreefeedClientBuilder
  include Callee

  def call
    Freefeed::Client.new(
      token: Rails.application.credentials.freefeed_token,
      base_url: Rails.application.credentials.freefeed_base_url
    )
  end
end
