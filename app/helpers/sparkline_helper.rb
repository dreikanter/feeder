module SparklineHelper
  def generate_feed_sparkline(feed)
    tag.span(class: "sparkline") do
      feed.sparkline_points.each do |point|
        concat(
          tag.span(
            title: sparkline_tooltip(point["date"], point["value"].to_i),
            class: "sparkline__item",
            data: {bs_toggle: "tooltip", bs_placement: "top"}
          ) { point["sparky"].presence || "&nbsp;".html_safe }
        )
      end
    end
  end

  private

  def sparkline_tooltip(date, value)
    formatted_date = date.strftime("%F")
    posts_count = "post".pluralize(value)
    "#{formatted_date}: #{value} #{posts_count}"
  end
end
