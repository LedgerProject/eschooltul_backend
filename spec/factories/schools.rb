FactoryBot.define do
  factory :school do
    name { "MyString" }
    sequence :email do |number|
      "school#{number}@mail.com"
    end
    address { "" }
    city { "" }
  end
end
