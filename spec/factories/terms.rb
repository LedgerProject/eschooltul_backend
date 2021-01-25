FactoryBot.define do
  factory :term do
    sequence :name do |i|
      "Trimester #{i}"
    end
    course
  end
end
