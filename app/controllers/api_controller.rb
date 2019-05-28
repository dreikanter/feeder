class APIController < ActionController::API
  include Operations::Performable

  respond_to :json

  rescue_from StandardError do |ex|
    handle_error(ex, :internal_server_error, error: 'Internal server error')
  end

  rescue_from ActiveRecord::RecordNotFound do |ex|
    handle_error(ex, :not_found, error: 'Not found')
  end

  rescue_from ActionController::ParameterMissing do |ex|
    handle_error(ex, :bad_request, error: 'Bad request')
  end

  rescue_from ActionController::UnpermittedParameters do |ex|
    handle_error(ex, :bad_request, error: e.message)
  end

  private

  def handle_error(exception, status, payload = nil)
    Rails.logger.error(exception)
    render(status: status, json: payload)
  end
end
