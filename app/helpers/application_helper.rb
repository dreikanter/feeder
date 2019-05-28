# TODO: Drop this after React refactoring
module ApplicationHelper
  def time_ago_tag(time)
    readable_time_tag(time, 'ago')
  end

  def readable_time_tag(time, css_class = nil)
    return '' unless time
    time = time.to_time
    time_tag(time, time.strftime("%Y-%m-%d %H:%M"), class: css_class)
  end
end
