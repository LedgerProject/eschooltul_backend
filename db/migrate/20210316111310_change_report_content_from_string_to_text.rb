class ChangeReportContentFromStringToText < ActiveRecord::Migration[6.0]
  def change
    change_column :reports, :content, :text # rubocop:disable Rails/ReversibleMigration
  end
end
