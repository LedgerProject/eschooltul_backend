class AddfieldsToStudent < ActiveRecord::Migration[6.0]
  def change
    change_table :students, bulk: true do |t|
      t.date :birthday
      t.string :city
      t.string :state_or_tegion
      t.string :postal_code
      t.string :country
    end
  end
end
