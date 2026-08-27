class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  layout "application"

  before_action :render_blank_json, unless: -> { request.format.html? }

  private

  # NOTE: The app has HTML views only, so requests asking for another format
  #  (e.g. uptime monitors sending "Accept: application/json") would fail with
  #  ActionView::MissingTemplate.
  def render_blank_json
    render(json: {})
  end
end
