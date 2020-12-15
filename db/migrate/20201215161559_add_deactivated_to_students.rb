class AddDeactivatedToStudents < ActiveRecord::Migration[6.0]
  def change
    add_column :students, :deactivated, :boolean, default: false
    add_index :students, :deactivated
  end
end
