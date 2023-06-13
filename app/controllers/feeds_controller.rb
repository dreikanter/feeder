class FeedsController < ApplicationController
  def index
    render(locals: locals)
  end

  private

  def locals
    {
      feeds: Feed.ordered_by(order_by, order),
      active_feeds_count: Feed.active.count,
      last_post_created_at: Post.maximum(:created_at),
      last_update: Feed.maximum(:refreshed_at),
      order: order,
      order_by: order_by
    }
  end

  def order_by
    @order_by ||= EnumParamSanitizer.call(
      params[:order_by],
      default: "state",
      available: %w[
        name
        state
        posts_count
        refreshed_at
        last_post_created_at
      ]
    )
  end

  def order
    @order ||= EnumParamSanitizer.call(
      params[:order],
      default: "desc",
      available: %w[asc desc]
    )
  end
end
