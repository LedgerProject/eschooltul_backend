class ChangeTransactionIdToString < ActiveRecord::Migration[6.0]
  def change
    change_column :reports, :transaction_id, :string
  end
end
