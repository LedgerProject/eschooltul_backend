class AddUniqueIndexReport < ActiveRecord::Migration[6.0]
  def change
    add_index :reports, :content_hash, unique: true
  end
end
