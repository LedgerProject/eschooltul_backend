module Grades
  class LessonTypesController < GradesController
    def index
      @course = find_current_course
      @lesson_types = LessonType.order(:name).page(params[:page])
    end

    def new
      @course = find_current_course
      @lesson_type = LessonType.new
    end

    def create
      @course = find_current_course
      @lesson_type = LessonType.new(lesson_type_params)

      if @lesson_type.save
        redirect_to grades_course_lesson_types_path(@course),
                    notice: t("flash.actions.create.notice",
                              resource_name: t("lesson_type.lesson_type"))
      else
        render :new
      end
    end

    def edit
      @course = find_current_course
      @lesson_type = find_lesson_type
    end

    def update
      @course = find_current_course
      @lesson_type = find_lesson_type

      if @lesson_type.update(lesson_type_params)
        redirect_to grades_course_lesson_types_path(@course),
                    notice: t("flash.actions.update.notice",
                              resource_name: t("lesson_type.lesson_type"))
      else
        render :edit
      end
    end

    def destroy
      @course = find_current_course
      @lesson_type = find_lesson_type

      @lesson_type.destroy
      redirect_to grades_course_lesson_types_path(@course),
                  notice: t("flash.actions.destroy.notice",
                            resource_name: t("lesson_type.lesson_type"))
    end

    private

    def lesson_type_params
      params.require(:lesson_type).permit(:name)
    end

    def find_lesson_type
      LessonType.find(params[:id])
    end
  end
end
