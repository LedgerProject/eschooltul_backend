class GradesController < AuthenticatedController
  def index
    redirect_to courses_path if find_courses.count.zero?
    @courses = find_courses
  end

  def show
    pdf = WickedPdf.new.pdf_from_string(
      render_to_string(
        template: "grades/show",
        encoding: "UTF-8",
        locals: { student: find_student, course: find_course, school: find_school,
                  mark_value: find_mark_value }
      )
    )
    pdf_to_database(pdf)
    pdf_to_blockchain(pdf, @report.id)
  end

  def create
    marks = JSON.parse(params[:marks])
    grades = Grade.new
    grades.save_grades(marks)

    head :ok
  end

  def find_course
    Course.find(params[:course_id])
  end

  def check_permission_on_this_course
    redirect_to grades_courses_path if current_user.course?(params[:course_id])
  end

  private

  def find_courses
    return teacher_grades if current_user.teacher?

    all_grades
  end

  def find_student
    Student.find(params[:id])
  end

  def find_school
    School.first(params[:school_id])
  end

  def find_mark_value
    find_course.marks.find_by(student_id: find_student.id).value
  end

  def pdf_to_database(pdf)
    @report = find_student.reports.create(
      content: Base64.encode64(pdf),
      content_hash: Digest::SHA256.hexdigest(Base64.encode64(pdf)),
      course_id: find_course.id, date: Time.zone.today
    )
    send_data pdf, filename: "#{find_student.full_name}#{find_course.full_name}.pdf"
  end

  def pdf_to_blockchain(pdf, report_id)
    base64 = Digest::SHA256.hexdigest(Base64.encode64(pdf))

    HTTParty.post(
      "https://apiroom.net/api/serveba/sawroom-write",
      body: {
        dataToStore: base64,
        reportID: report_id
      }
    )
  end

  def teacher_grades
    Course.where(user_id: current_user.id)
          .includes(:terms, :students, :lessons)
          .map do |course|
      course.as_json.merge({
                             terms: course.terms.as_json,
                             students: with_marks(course.students),
                             lessons: course.lessons.as_json
                           })
    end
  end

  def all_grades
    Course.includes(:terms, :students, :lessons)
          .map do |course|
      course.as_json.merge({
                             terms: course.terms.as_json,
                             students: with_marks(course.students),
                             lessons: course.lessons.as_json
                           })
    end
  end

  def with_marks(students)
    students.includes(:marks)
            .map do |student|
      student.as_json.merge({ marks: student.marks.as_json })
    end
  end
end
