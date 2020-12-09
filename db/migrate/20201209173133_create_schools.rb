class CreateSchools < ActiveRecord::Migration[6.0]
  def change
    create_table :schools do |t|
      t.string :name
      t.string :email
      t.string :address
      t.string :city

      t.timestamps
    end
  end
end
