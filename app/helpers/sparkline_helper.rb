module SparklineHelper
  def generate_feed_sparkline(feed)
    tag.span(class: "font-monospace") do
      feed.sparkline_points.each do |point|
        concat(tag.span(title: sparkline_tooltip(point['date'], point["value"])) { point["sparky"] })
      end
    end
  end

  private

  def sparkline_tooltip(date, value)
    formatted_date = date.strftime('%F')
    posts_count = 'post'.pluralize(value)
    "#{formatted_date}: #{posts_count}"
  end
end
