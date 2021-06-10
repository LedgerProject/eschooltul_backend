class StudentEdasController < AuthenticatedController
  EDAS_PARAMS = %i[
    student_code
    mode_of_study
    mode_of_delivery
    language
    email_address
    certification_date
    course_unit_type
    date
    ECTS_grading_scale_type
    country
    national_framework_qualifications
    percent
    source_grade
    year_of_study
    framework_code
    group_identifier
    institution_identifier
    suplement_language
    gender
    source_course_code
    number_of_years
  ].freeze

  def new
    @student_eda = StudentEda.new
  end

  def create
    @student_eda = StudentEda.new(eda_params)
    @student_eda.student = find_student
    if @student_eda.save
      xml_file = render_to_string(template: "student_edas/student_eda.xml.builder")
      send_data(xml_file, type: "text/xml", filename: "#{find_student.full_name}_EDA.xml")
    else
      render :new
    end
  end

  private

  def find_student
    Student.find(params[:student_id])
  end

  def find_eda
    StudentEda.find(params[:id])
  end

  def eda_params
    params.require(:student_eda).permit(*EDAS_PARAMS)
  end
end
