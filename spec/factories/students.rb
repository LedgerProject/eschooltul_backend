FactoryBot.define do
  factory :student do
    name { "MyString" }
    birthday { DateTime.new(2011, 1, 1) }
    first_surname { "MyString" }
    second_surname { "MyString" }
    telephone { "MyString" }
    diseases { "MyString" }
    observations { "MyText" }

    trait :deactivated do
      deactivated { true }
    end
  end
end
