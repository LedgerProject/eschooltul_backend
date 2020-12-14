class AddUniqueIndexCourses < ActiveRecord::Migration[6.0]
  def change
    add_index :courses, %i[subject name], unique: true
  end
end
