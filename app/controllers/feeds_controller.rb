class FeedsController < ApplicationController
  def index
    render(locals: locals)
  end

  private

  def locals
    {
      feeds: Feed.ordered_by(order_by, order),
      active_feeds_count: active_feeds_count,
      last_post_created_at: last_post_created_at,
      last_update: last_update,
      order: order,
      order_by: order_by,
      alt_order_direction: alt_order_direction
    }
  end

  def active_feeds_count
    Feed.active.count
  end

  def last_post_created_at
    Post.order(created_at: :desc).first.try(:created_at)
  end

  def last_update
    DataPoint.ordered_by_created_at.for('pull').first.try(:created_at)
  end

  def alt_order_direction
    order == 'asc' ? 'desc' : order
  end

  def order_by
    @order_by ||= ParamSanitizer.call(
      params[:order_by],
      default: 'status',
      available: %w[
        name
        status
        posts_count
        refreshed_at
        last_post_created_at
      ]
    )
  end

  def order
    @order ||= ParamSanitizer.call(
      params[:order],
      default: 'desc',
      available: %w[asc desc]
    )
  end
end
