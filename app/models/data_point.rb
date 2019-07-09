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

  CREATE_METHOD_PREFIX = 'create_'.freeze

  scope :ordered, -> { order(created_at: :desc) }
  scope :recent, -> { ordered.limit(RECENT_LIMIT) }

  def self.method_missing(method_name, details = {})
    return super unless valid_create_method_name?(method_name)

    series = method_name.to_s.sub(/^#{CREATE_METHOD_PREFIX}/, '')
    DataPoint.create(
      series: DataPointSeries.find_or_create_by(name: series),
      details: details
    )
  end

  def respond_to_missing?(method_name)
    valid_create_method_name?(method_name) || super
  end

  def self.for(series_name)
    DataPoint.where(series: DataPointSeries.find_by(name: series_name))
  end

  private

  def valid_create_method_name?(method_name)
    method_name.to_s.starts_with?(CREATE_METHOD_PREFIX)
  end
end
