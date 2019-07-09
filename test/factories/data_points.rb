FactoryBot.define do
  factory :data_point, class: DataPoint do
    series_id { 0 }
    details { {} }
    created_at { Time.new.utc }
  end
end
