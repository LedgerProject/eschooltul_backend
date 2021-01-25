FactoryBot.define do
  factory :lesson do
    sequence :name do |i|
      "Addition #{i}"
    end
    description { "Complete all the additions listed on page 3" }
    grading_method { "We will test the skilled of students when doing additions" }
    lesson_type
    course
    term
  end
end
