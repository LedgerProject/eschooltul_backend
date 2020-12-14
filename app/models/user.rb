class User < ApplicationRecord
  rolify
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable

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
end
