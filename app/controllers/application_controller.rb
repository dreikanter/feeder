class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  layout "application"

  before_action :force_html_format

  private

  # NOTE: The app has HTML views only, so requests asking for another format
  #  (e.g. uptime monitors sending "Accept: application/json") would fail with
  #  ActionView::MissingTemplate.
  def force_html_format
    request.format = :html
  end
end
