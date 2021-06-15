class ChangeColumnName < ActiveRecord::Migration[6.0]
  def change
    rename_column :students, :state_or_tegion, :state_or_region
  end
end
