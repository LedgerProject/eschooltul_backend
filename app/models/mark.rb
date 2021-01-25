class Mark < ApplicationRecord
  belongs_to :student
  belongs_to :remarkable, polymorphic: true
end
