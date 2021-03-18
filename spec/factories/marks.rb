FactoryBot.define do
  factory :mark do
    value { 9.9 }
    student { nil }
    remarkable { nil }

    trait :with_course do
      association :remarkable, factory: :course
    end
  end
end
