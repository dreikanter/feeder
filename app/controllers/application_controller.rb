class ApplicationController < ActionController::Base
  include Operations::Performable

  protect_from_forgery with: :exception
end
