class CreateReports < ActiveRecord::Migration[6.0]
  def change
    create_table :reports do |t|
      t.string :content
      t.string :hash
      t.integer :transaction_id

      t.timestamps
    end
  end
end
