module Grades
  class TermsController < GradesController
    before_action :check_permission_on_this_course

    def index
      @course = find_current_course
      @terms = find_current_course.terms.order(:name).page(params[:page])
    end

    def new
      @course = find_current_course
      @term = Term.new
    end

    def create
      @course = find_current_course
      @term = find_current_course.terms.build(term_params)

      if @term.save
        redirect_to grades_course_terms_path(@course),
                    notice: t("flash.actions.create.notice", resource_name: t("term.term"))
      else
        render :new
      end
    end

    def edit
      @course = find_current_course
      @term = find_term
    end

    def update
      @course = find_current_course
      @term = find_term

      if @term.update(term_params)
        redirect_to grades_course_terms_path(@course),
                    notice: t("flash.actions.update.notice", resource_name: t("term.term"))
      else
        render :edit
      end
    end

    def destroy
      @term = find_term
      @term.destroy

      redirect_to grades_course_terms_path,
                  notice: t("flash.actions.destroy.notice", resource_name: t("term.term"))
    end

    private

    def term_params
      params.require(:term).permit(:name)
    end

    def find_term
      Term.find(params[:id])
    end
  end
end
