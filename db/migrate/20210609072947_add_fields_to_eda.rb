class AddFieldsToEda < ActiveRecord::Migration[6.0]
  def change
    change_table :student_edas, bulk: true do |t|
      t.string :country
      t.integer :year_of_study
      t.string :framework_code
      t.string :group_identifier
      t.string :institution_identifier
      t.string :suplement_language
      t.string :gender
      t.string :source_course_code
      t.integer :number_of_years
    end
  end
end
