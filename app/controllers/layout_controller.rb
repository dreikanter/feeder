class LayoutController < ApplicationController
  def show
    render(html: '', layout: 'application')
  end
end
