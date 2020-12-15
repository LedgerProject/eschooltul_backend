class CreateStudents < ActiveRecord::Migration[6.0]
  def change
    create_table :students do |t|
      t.string :name
      t.integer :age
      t.string :first_surname
      t.string :second_surname
      t.string :address
      t.string :telephone
      t.string :diseases
      t.text :observations

      t.timestamps
    end
  end
end
