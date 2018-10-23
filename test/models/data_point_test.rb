# == Schema Information
#
# Table name: data_points
#
#  id         :integer          not null, primary key
#  series_id  :integer
#  details    :json             not null
#  created_at :datetime         not null
#
# Indexes
#
#  index_data_points_on_series_id  (series_id)
#

require "test_helper"

class DataPointTest < Minitest::Test
  def data_point
    @data_point ||= DataPoint.new
  end

  def test_valid
    assert data_point.valid?
  end
end
