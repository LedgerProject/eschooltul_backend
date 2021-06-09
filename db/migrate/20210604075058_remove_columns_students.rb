class RemoveColumnsStudents < ActiveRecord::Migration[6.0]
  def up
    change_table :students, bulk: true do |t|
      t.remove :age, :address
    end
  end
end
