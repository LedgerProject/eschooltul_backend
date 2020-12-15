class User < ApplicationRecord
  rolify
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable

  has_many :courses, dependent: :nullify

  def self.teachers
    with_role(:teacher)
  end

  def name
    email
  end

  def director?
    has_role?(:director)
  end

  def administrator?
    has_role?(:administrator)
  end

  def teacher?
    has_role?(:teacher)
  end
end
