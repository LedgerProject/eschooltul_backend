class DocumentReport < ApplicationRecord
  belongs_to :student

  def content_hash?(hash)
    content_hash == hash
  end
end
