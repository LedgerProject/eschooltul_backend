FactoryBot.define do
  factory :lesson_type do
    sequence :name do |i|
      "Exercise_#{i}"
    end
  end
end
