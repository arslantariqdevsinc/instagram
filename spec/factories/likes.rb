FactoryBot.define do
  factory :like do
    user

    trait :for_post do
      association :likeable, factory: :post
    end
  end
end
