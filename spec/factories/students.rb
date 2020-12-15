FactoryBot.define do
  factory :student do
    name { "MyString" }
    age { 10 }
    first_surname { "MyString" }
    second_surname { "MyString" }
    address { "MyString" }
    telephone { "MyString" }
    diseases { "MyString" }
    observations { "MyText" }

    trait :deactivated do
      deactivated { true }
    end
  end
end
