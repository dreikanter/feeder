FactoryBot.define do
  factory :data_point_series, class: DataPointSeries do
    name { SecureRandom.hex }
  end
end
