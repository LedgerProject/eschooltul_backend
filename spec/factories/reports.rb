FactoryBot.define do
  factory :report do
    content { "MyString" }
    content_hash { "MyString" }
    transaction_id { "" }
    course
    student
  end
end
