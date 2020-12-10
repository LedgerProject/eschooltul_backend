class User < ApplicationRecord
  rolify
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable

  def administrator?
    has_role?(:administrator)
  end
end
