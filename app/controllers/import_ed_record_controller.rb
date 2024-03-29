class ImportEdRecordController < AuthenticatedController
  def new
    @import_student = ImportEdRecord.new
  end

  def create
    @import_student = ImportEdRecord.new(import_student_params)

    counter_saved, counter_failed = @import_student.upload_records

    redirect_to students_path,
                notice: t("saved_failed", counter_saved:,
                                          counter_failed:)
  end

  private

  def import_student_params
    params.require(:import_ed_record).permit(:attachment)
  end
end
