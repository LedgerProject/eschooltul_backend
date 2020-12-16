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
      redirect_to students_path, notice: "Student was successfully created."
    else
      render :new
    end
  end

  def deactivate
    student = find_student
    student.toggle(:deactivated)
    student.save!

    activation_message = student.deactivated ? "disabled" : "enabled"
    redirect_to students_path, notice: "Student was #{activation_message}"
  end

  def update
    @student = find_student
    if @student.update(student_params)
      redirect_to students_path, notice: "Student was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @student = find_student
    @student.destroy
    redirect_to students_path, notice: "Student was successfully destroyed."
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
                                    :telephone, :diseases, :observations)
  end
end
