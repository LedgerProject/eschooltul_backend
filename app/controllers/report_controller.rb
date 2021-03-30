class ReportController < AuthenticatedController
  def show
    pdf = WickedPdf.new.pdf_from_string(
      render_to_string(
        template: "report/show.pdf",
        encoding: "UTF-8",
        locals: { student: find_student, course: find_course, school: find_school,
                  mark_value: find_mark_value }
      )
    )
    report = pdf_to_database(pdf)
    pdf_to_blockchain(report: report)
  end

  private

  def find_course
    Course.find(params[:course_id])
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
    report = find_student.reports.create(
      content: Base64.encode64(pdf),
      content_hash: Digest::SHA256.hexdigest(Base64.encode64(pdf)),
      course_id: find_course.id, date: Time.zone.today
    )
    send_data pdf, filename: "#{find_student.full_name}#{find_course.full_name}.pdf"
    report
  end

  def pdf_to_blockchain(report:)
    body = { "data": { "dataToStore": report.content_hash, "reportID": report.id }, "keys": {} }
    response = HTTParty.post(
      "https://apiroom.net/api/serveba/sawroom-write",
      body: body.to_json,
      headers: { "Content-Type" => "application/json" }
    )
    report.update!(transaction_id: response["transactionId"])
  end

  def report_params
    params.require(:report).permit(:content, :hash, :transaction_id)
  end
end
