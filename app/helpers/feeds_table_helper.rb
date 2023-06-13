module FeedsTableHelper
  def feeds_table_header(order_by:, order:)
    tag.thead do
      tag.tr do
        FEED_TABLE_COLUMNS.each do |attribute, column|
          concat(
            tag.th do
              asc_order = order == "asc"
              current_attribute = order_by == attribute

              alt_order = asc_order ? "desc" : "asc"
              column_order = current_attribute ? alt_order : column[:order]
              concat(link_to(column[:caption], feeds_path(order_by: attribute, order: column_order)))

              arrow = asc_order ? " ↓" : " ↑"
              concat(current_attribute ? arrow : "")
            end
          )
        end
      end
    end
  end

  private

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
