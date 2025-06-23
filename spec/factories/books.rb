FactoryBot.define do
  factory :book do
    title { "Sample Book" }
    association :author
  end
end
