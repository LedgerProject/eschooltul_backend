class User < ApplicationRecord
  rolify
  paginates_per 6
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable

  def self.teachers
    with_role(:teacher)
  end

  def complete_name
    "#{name} #{first_surname} #{second_surname}"
  end

  def director?
    has_role?(:director)
  end

  def administrator?
    has_role?(:administrator)
  end
end
