module FeedsTableHelper
  def feeds_table_header(order_by:, order:)
    tag.thead do
      tag.tr do
        FEED_TABLE_COLUMNS.each do |attribute, column|
          concat(
            tag.th do
              column_order = order_direction(attribute: attribute, default: column[:order], current_order_by: order_by, current_order: order)
              concat(link_to(column[:caption], feeds_path(order_by: attribute, order: column_order)))
              concat((order_by == attribute) ? ((order == "asc") ? " ↓" : " ↑") : "")
            end
          )
        end
      end
    end
  end

  private

  def order_direction(attribute:, default:, current_order_by:, current_order:)
    (current_order_by == attribute) ? ((current_order == "asc") ? "desc" : "asc") : default
  end

  FEED_STATE_CLASSES = {
    "enabled" => "text-success",
    "disabled" => "text-muted",
    "removed" => "text-muted"
  }.freeze

  private_constant :FEED_STATE_CLASSES

  def feed_state_class(state)
    FEED_STATE_CLASSES[state]
  end

  FEED_TABLE_COLUMNS = {
    "name" => {
      caption: "Name",
      order: "asc"
    },
    "state" => {
      caption: "State",
      order: "asc"
    },
    "posts_count" => {
      caption: "Posts",
      order: "desc"
    },
    "refreshed_at" => {
      caption: "Refreshed at",
      order: "desc"
    },
    "last_post_created_at" => {
      caption: "Last post",
      order: "desc"
    }
  }.freeze

  private_constant :FEED_TABLE_COLUMNS
end
