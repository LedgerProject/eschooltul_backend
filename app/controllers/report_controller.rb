class ReportController < AuthenticatedController
  private

  def report_params
    params.require(:report).permit(:content, :hash, :transaction_id)
  end
end
