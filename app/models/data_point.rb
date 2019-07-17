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
  belongs_to :series, class_name: 'DataPointSeries'

  # TODO: Consider moving configuration values to configuration
  RECENT_LIMIT = 50

  scope :ordered, -> { order(created_at: :desc) }
  scope :recent, -> { ordered.limit(RECENT_LIMIT) }

  def self.for(series_name)
    DataPoint.where(series: DataPointSeries.find_by(name: series_name))
  end
end
