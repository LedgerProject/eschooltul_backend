module Grades
  class LessonsController < GradesController
    def index
      @course = find_course
      @terms = @course.terms
      @lessons = find_lessons
    end

    def new
      @course = find_course
      @lesson = Lesson.new
    end

    def create
      @course = find_course
      @lesson = @course.lessons.build(lesson_params)

      if @lesson.save
        redirect_to grades_course_lessons_path(@course),
                    notice: "Lesson created successfully"
      else
        render :new
      end
    end

    def edit
      @course = find_course
      @lesson = find_lesson
    end

    def update
      @course = find_course
      @lesson = find_lesson

      if @lesson.update(lesson_params)
        redirect_to grades_course_lessons_path(@course),
                    notice: "Lesson updated successfully"
      else
        render :edit
      end
    end

    def destroy
      @course = find_course
      @lesson = find_lesson

      @lesson.destroy
      redirect_to grades_course_lessons_path(@course),
                  notice: "Lesson was successfully destroyed"
    end

    private

    def find_lessons
      @search = find_course.lessons.ransack(params[:q])
      @lessons = @search.result(distinct: true).order(:name).page(params[:page])
    end

    def find_lesson
      Lesson.find(params[:id])
    end

    def lesson_params
      params.require(:lesson).permit(
        :name,
        :description,
        :grading_method,
        :lesson_type_id,
        :term_id
      )
    end
  end
end
