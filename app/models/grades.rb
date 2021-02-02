class Grades
  include ActiveModel::Model

  def save_grades(marks)
    marks.each do |mark|
      if mark_exists?(mark)
        Mark.create(mark)
      else
        find_mark(mark).update(mark)
      end
    end
  end

  def mark_exists?(mark)
    find_mark(mark).nil?
  end

  def find_mark(mark)
    Mark.find_by(
      remarkable_id: mark["remarkable_id"],
      remarkable_type: mark["remarkable_type"],
      student_id: mark["student_id"]
    )
  end
end
