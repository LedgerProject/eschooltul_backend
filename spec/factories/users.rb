FactoryBot.define do
  factory :user do
    sequence :email do |number|
      "person#{number}@mail.com"
    end
    password { "password" }

    trait :director do
      after(:create) do |user|
        user.add_role(:director)
      end
    end

    trait :teacher do
      after(:create) do |user|
        user.add_role(:teacher)
      end
    end
  end
end
