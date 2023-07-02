FactoryBot.define do
  factory :service_instance do
    service_type { "sample" }
    state { "enabled" }
    sequence(:url) { "https://example.com/#{_1}" }
    errors_count { 0 }
    total_errors_count { 0 }
    used_at {}
    failed_at {}
  end
end
