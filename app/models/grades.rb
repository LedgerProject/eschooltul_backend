class Grades
  include ActiveModel::Model

  def save_grades(marks)
    marks.each do |mark|
      create_mark(mark) unless mark?(mark)

      delete_mark(mark) if delete?(mark)

      update_mark(mark) if update?(mark)
    end
  end

  private

  def find_mark(mark)
    Mark.find_by(
      remarkable_id: mark["remarkable_id"],
      remarkable_type: mark["remarkable_type"],
      student_id: mark["student_id"]
    )
  end

  def delete?(mark)
    mark?(mark) && !value?(mark["value"])
  end

  def update?(mark)
    mark?(mark) && value?(mark["value"])
  end

  def mark?(mark)
    !find_mark(mark).nil?
  end

  def value?(value)
    !value.nil?
  end

  def update_mark(mark)
    find_mark(mark).update(mark)
  end

  def create_mark(mark)
    Mark.create(mark)
  end

  def delete_mark(mark)
    find_mark(mark).destroy
  end
end
