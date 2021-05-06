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
                                                           activation_message: activation_message)
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
    params.require(:student).permit(:name, :age, :first_surname, :second_surname, :address,
                                    :telephone, :diseases, :observations, documents: [])
  end

  def documents_to_blockchain
    return if params[:student][:documents].nil?

    documents_size = params[:student][:documents].size
    student_documents = @student.documents.order(created_at: :desc).last(documents_size)

    student_documents.each do |document|
      send_document_to_blockchain(document)
    end
  end

  def send_document_to_blockchain(document)
    report_hash = Digest::SHA256.hexdigest(Base64.encode64(document.download))
    body = { "data": { "dataToStore": report_hash, "documentID": document.id }, "keys": {} }
    HTTParty.post(
      "https://apiroom.net/api/serveba/sawroom-write-document",
      body: body.to_json,
      headers: { "Content-Type" => "application/json" }
    )
  end
end
