class RenameColumnReport < ActiveRecord::Migration[6.0]
  def change
    rename_column :reports, :hash, :content_hash
  end
end
