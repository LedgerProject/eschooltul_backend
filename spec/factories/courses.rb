FactoryBot.define do
  factory :course do
    name { "3-B " }
    sequence :subject do |i|
      "Maths #{i}"
    end
    user
  end
end
