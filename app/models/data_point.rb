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

class DataPoint < ApplicationRecord
  belongs_to :series, class_name: "DataPointSeries"

  scope :ordered_by_created_at, -> { order(created_at: :desc) }

  def self.for(series_name)
    DataPoint.where(series: DataPointSeries.find_by(name: series_name))
  end
end
