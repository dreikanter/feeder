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

class DataPointSeries < ApplicationRecord
end
