class Report < ApplicationRecord
  belongs_to :student
  belongs_to :course
  validates :content_hash, uniqueness: true
  validates :student_id,
            uniqueness: { scope: %i[course_id date],
                          message: "This report is already in the database" }

  def self.calculate_hash(content)
    Digest::SHA256.hexdigest(Base64.encode64(content))
  end

  def content_hash?(hash)
    content_hash == hash
  end
end
