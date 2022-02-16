class ReportPdfController < AuthenticatedController
  def show
    report = find_report
    return if report.blank?

    pdf = Base64.decode64(report.content)
    send_data(pdf, filename: report.filename)
  end

  private

  def find_report
    Report.find(params[:id])
  end
end
