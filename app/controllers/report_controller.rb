class ReportController < AuthenticatedController
  def show
    if find_course_mark.blank?
      redirect_to grades_course_path(find_course), alert: t("report.action.nogrades")
      return
    end
    if find_report.present?
      pdf = Base64.decode64(find_report.content)
      send_data(pdf, filename: find_report.filename)
      return
    end
    create_report_with_pdf
  end

  private

  def report_params
    params.require(:report).permit(:content, :hash, :transaction_id)
  end

  def find_report
    Report.find_by(student: find_student, course: find_course, date: Time.zone.today)
  end

  def find_course
    Course.find(params[:course_id])
  end

  def find_student
    Student.find(params[:id])
  end

  def find_school
    School.first(params[:school_id])
  end

  def find_course_mark
    find_course.marks.find_by(student_id: find_student.id)
  end

  def create_report_with_pdf
    pdf = create_pdf

    report = create_report(pdf)
    report_to_blockchain(report)

    send_data(pdf, filename: report.filename)
  end

  def create_pdf
    pdf_string = render_to_string(
      template: "report/show",
      encoding: "UTF-8",
      locals: pdf_locals
    )
    WickedPdf.new.pdf_from_string(pdf_string)
  end

  def pdf_locals
    {
      student: find_student,
      course: find_course,
      school: find_school,
      mark_value: find_course_mark.value
    }
  end

  def create_report(pdf)
    find_student.reports.create(
      content: Base64.encode64(pdf),
      content_hash: Digest::SHA256.hexdigest(Base64.encode64(pdf)),
      course_id: find_course.id,
      date: Time.zone.today
    )
  end

  def report_to_blockchain(report)
    body = { data: { dataToStore: report.content_hash,
                     reportID: report.id.to_s }, keys: {} }
    response = HTTParty.post(
      "https://apiroom.net/api/serveba/sawroom-write",
      body: body.to_json,
      headers: { "Content-Type" => "application/json" }
    )
    report.update!(transaction_id: response["transactionId"])
  end
end
