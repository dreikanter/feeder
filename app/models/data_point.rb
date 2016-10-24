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

  RECENT_LIMIT = 50
  KEEP_RECORDS_FOR = 3.weeks

  scope :ordered, -> { order(created_at: :desc) }
  scope :recent, -> { ordered.limit(RECENT_LIMIT) }

  def self.method_missing(method_name, *args)
    return super unless method_name.to_s.starts_with?('create_')
    series = method_name.to_s.sub(/^create_/, '')
    DataPoint.create(
      series: DataPointSeries.find_or_create_by(name: series),
      details: args.first
    )
  end

  def self.for(series_name)
    DataPoint.where(series: DataPointSeries.find_by_name(series_name))
  rescue
    DataPoint.none
  end

  def self.purge_old_records!
    DataPoint.where('created_at < ?', KEEP_RECORDS_FOR.ago).delete_all
  end
end
