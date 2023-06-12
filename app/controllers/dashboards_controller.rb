class DashboardsController < ApplicationController
  def show
    render(locals: show_locals)
  end

  private

  def show_locals
    {
      feeds: Feed.ordered,
      last_post_created_at: last_post_created_at,
      last_update: last_update
    }
  end

  def last_post_created_at
    Post.order(created_at: :desc).first.try(:created_at)
  end

  def last_update
    DataPoint.ordered.for("pull").first.try(:created_at)
  end
end
