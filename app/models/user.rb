class User < ApplicationRecord
  before_destroy :validate_last_director
  before_destroy :set_courses_to_director
  rolify
  paginates_per 6
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable

  has_many :courses, dependent: :nullify

  def self.teachers
    with_role(:teacher)
  end

  def complete_name
    [name, first_surname, second_surname].join(" ")
  end

  def director?
    has_role?(:director)
  end

  def administrator?
    has_role?(:administrator)
  end

  def validate_last_director
    if has_role?(:director) && User.with_role(:director).count <= 1
      throw(:abort)
    else
      true
    end
  end

  def set_courses_to_director
    return unless courses.count.positive?

    director_id = User.with_role(:director).first.id
    courses.each do |course|
      course.user_id = director_id
      course.save!
    end
  end

  def role
    roles.first.name
  end

  def teacher?
    has_role?(:teacher)
  end

  def course?(params)
    teacher? && courses.find_by(id: params).nil?
  end
end
