class StudentsController < AuthenticatedController
  def index
    @students = Student.all
  end

  def show
    @student = find_student
  end

  def new
    @student = Student.new
  end

  def edit
    @student = find_student
  end

  def create
    @student = Student.new(student_params)

    if @student.save
      redirect_to @student, notice: "Student was successfully created."
    else
      render :new
    end
  end

  def update
    @student = find_student
    if @student.update(student_params)
      redirect_to @student, notice: "Student was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @student = find_student
    @student.destroy
    redirect_to students_url, notice: "Student was successfully destroyed."
  end

  private

  def find_student
    Student.find(params[:id])
  end

  def student_params
    params.require(:student).permit(:name, :age, :first_surname, :second_surname, :address,
                                    :telephone, :diseases, :observations)
  end
end
