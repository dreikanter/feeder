module FeedsTableHelper
  def feeds_table_header(order_by:, order:)
    tag.thead do
      tag.tr do
        FEED_TABLE_COLUMNS.each do |attribute, column|
          concat(
            tag.th(class: column[:classes]) do
              asc_order = order == "asc"
              current_attribute = order_by == attribute

              alt_order = asc_order ? "desc" : "asc"
              column_order = current_attribute ? alt_order : column[:order]
              concat(link_to(column[:caption], feeds_path(order_by: attribute, order: column_order), class: "text-body"))

              arrow = asc_order ? " ↓" : " ↑"
              concat(current_attribute ? arrow : "")
            end
          )
        end
      end
    end
  end

  private

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
      caption: "Refreshed",
      order: "desc"
    },
    "last_post_created_at" => {
      caption: "Imports",
      order: "desc",
      classes: "feeds-table__sparkline-column"
    }
  }.freeze

  private_constant :FEED_TABLE_COLUMNS
end
