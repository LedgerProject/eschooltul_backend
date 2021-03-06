module Grades
  class LessonsController < GradesController
    before_action :check_permission_on_this_course

    def index
      @course = find_current_course
      @terms = @course.terms
      @lessons = find_lessons
      @lesson_types = LessonType.all
    end

    def new
      @course = find_current_course
      @lesson = Lesson.new
    end

    def create
      @course = find_current_course
      @lesson = @course.lessons.build(lesson_params)

      if @lesson.save
        redirect_to grades_course_lessons_path(@course),
                    notice: t("flash.actions.create.notice", resource_name: t("lesson.lesson"))
      else
        render :new
      end
    end

    def edit
      @course = find_current_course
      @lesson = find_lesson
    end

    def update
      @course = find_current_course
      @lesson = find_lesson

      if @lesson.update(lesson_params)
        redirect_to grades_course_lessons_path(@course),
                    notice: t("flash.actions.update.notice", resource_name: t("lesson.lesson"))
      else
        render :edit
      end
    end

    def destroy
      @course = find_current_course
      @lesson = find_lesson

      @lesson.destroy
      redirect_to grades_course_lessons_path(@course),
                  notice: t("flash.actions.destroy.notice", resource_name: t("lesson.lesson"))
    end

    private

    def find_lessons
      @search = find_current_course.lessons.ransack(params[:q])
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
