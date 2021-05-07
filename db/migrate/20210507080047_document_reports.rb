class DocumentReports < ActiveRecord::Migration[6.0]
  def change
    create_table :document_reports do |t|
      t.text :content
      t.string :content_hash, unique: true
      t.string :transaction_id
      t.belongs_to :student
      t.date :date

      t.timestamps
    end
  end
end
