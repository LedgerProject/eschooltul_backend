class User < ApplicationRecord
  before_destroy :validate_last_director
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

  def validate_last_director
    if has_role?(:director) && User.with_role(:director).count <= 1
      throw(:abort)
    else
      true
    end
  end
end
