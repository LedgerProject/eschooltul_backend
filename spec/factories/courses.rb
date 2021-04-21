FactoryBot.define do
  factory :course do
    name { "3-B " }
    sequence :subject do |i|
      "Maths #{i}"
    end
    user

    trait :discarded do
      discarded_at { Time.zone.now }
    end
  end
end
