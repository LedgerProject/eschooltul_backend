class ImportEdRecord
  include ActiveModel::Model

  attr_accessor :attachment

  validates :attachment, presence: true

  def upload_records
    wb = Roo::Spreadsheet.open attachment
    sheet = wb.sheet(0)
    sheet.parse(clean: true)

    counter_saved, counter_failed = save_sheet(sheet)
    [counter_saved, counter_failed]
  end

  def save_sheet(sheet)
    counter_saved = counter_failed = 0

    sheet.each(name: "Name", birthday: "Birthday", first_surname: "First_surname") do |hash|
      next if hash[:name] == "Name"

      student = Student.new(hash)

      counter_saved, counter_failed = save_student(student, counter_saved, counter_failed)
    end
    [counter_saved, counter_failed]
  end

  def save_student(student, counter_saved, counter_failed)
    if student.save
      counter_saved += 1
    else
      counter_failed += 1
    end
    [counter_saved, counter_failed]
  end
end
