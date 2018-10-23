# == Schema Information
#
# Table name: data_point_series
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#
# Indexes
#
#  index_data_point_series_on_name  (name) UNIQUE
#

require "test_helper"

class DataPointSeriesTest < Minitest::Test
  def data_point_series
    @data_point_series ||= DataPointSeries.new
  end

  def test_valid
    assert data_point_series.valid?
  end
end
