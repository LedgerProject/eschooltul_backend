class CreateMarks < ActiveRecord::Migration[6.0]
  def change
    create_table :marks do |t|
      t.decimal :value
      t.belongs_to :student, null: false, foreign_key: true
      t.references :remarkable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
