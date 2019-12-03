class FreefeedClientBuilder
  include Callee

  def call
    Freefeed::Client.new(
      token: Rails.application.credentials.freefeed_token,
      logger: Rails.logger,
      base_url: Rails.application.credentials.freefeed_base_url
    )
  end
end
