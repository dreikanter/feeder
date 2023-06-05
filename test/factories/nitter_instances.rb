FactoryBot.define do
  factory :nitter_instance do
    status { :enabled }
    url { 'https://example.com' }
  end
end
