class StudentsController < AuthenticatedController
  before_action :check_permission, except: %i[index edit update]
  def index
    @students = find_students
  end

  def new
    @student = Student.unscoped.new
  end

  def edit
    @student = find_student
  end

  def create
    @student = Student.unscoped.new(student_params)

    if @student.save
      redirect_to students_path,
                  notice: t("flash.actions.create.notice", resource_name: t("student.student"))
    else
      render :new
    end
  end

  def deactivate
    student = find_student
    student.toggle(:deactivated)
    student.save!

    activation_message = student.deactivated ? t(:disabled) : t(:enabled)
    redirect_to students_path,
                notice: t("flash.actions.activate.notice", resource_name: t("student.student"),
                                                           activation_message:)
  end

  def update
    @student = find_student
    if @student.update(student_params)
      documents_to_blockchain
      redirect_to students_path,
                  notice: t("flash.actions.update.notice", resource_name: t("student.student"))
    else
      render :edit
    end
  end

  def destroy
    @student = find_student
    @student.destroy
    redirect_to students_path,
                notice: t("flash.actions.destroy.notice", resource_name: t("student.student"))
  end

  private

  def find_students
    if current_user.teacher?
      current_user.courses.flat_map(&:students).uniq
    else
      Student.unscoped.order(:name).page(params[:page])
    end
  end

  def find_student
    Student.unscoped.find(params[:id])
  end

  def student_params
    params.require(:student).permit(:name, :birthday, :first_surname, :second_surname,
                                    :telephone, :diseases, :observations, :city,
                                    :state_or_region, :postal_code, :country, documents: [])
  end

  def documents_to_blockchain
    return if params[:student][:documents].nil?

    documents_size = params[:student][:documents].size
    student_documents = @student.documents.order(created_at: :desc).last(documents_size)

    student_documents.each do |document|
      report = create_document_report(document)
      send_document_to_blockchain(report)
    end
  end

  def create_document_report(document)
    @student.document_reports.create(
      content: encode_document(document),
      content_hash: Digest::SHA256.hexdigest(encode_document(document)),
      date: Time.zone.today
    )
  end

  def send_document_to_blockchain(report)
    body = { data: { dataToStore: report.content_hash,
                     reportID: report.id.to_s }, keys: {} }
    response = HTTParty.post(
      "#{ENV.fetch('ESTOOL_APIROOM_ENDPOINT') { 'https://apiroom.net' }}/api/serveba/sawroom-write",
      body: body.to_json,
      headers: { "Content-Type" => "application/json" }
    )
    report.update!(transaction_id: response["transactionId"])
  end

  def encode_document(document)
    Base64.encode64(document.download)
  end
end
