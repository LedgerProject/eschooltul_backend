class School < ApplicationRecord
  has_one_attached :logo

  def self.created?
    one?
  end
end
