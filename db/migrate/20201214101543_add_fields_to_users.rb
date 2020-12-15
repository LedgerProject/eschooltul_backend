class AddFieldsToUsers < ActiveRecord::Migration[6.0]
  def change
    change_table :users, bulk: true do |t|
      t.string :name
      t.string :first_surname
      t.string :second_surname
    end
  end
end
