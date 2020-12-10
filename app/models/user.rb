class User < ApplicationRecord
  rolify
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable

  def director?
    has_role?(:director)
  end

  def administrator?
    has_role?(:administrator)
  end
end
