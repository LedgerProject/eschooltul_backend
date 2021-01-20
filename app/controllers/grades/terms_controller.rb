module Grades
  class TermsController < GradesController
    def index
      @course = find_course
      @terms = find_course.terms.order(:name).page(params[:page])
    end

    def new
      @course = find_course
      @term = Term.new
    end

    def create
      @course = find_course
      @term = find_course.terms.build(term_params)

      if @term.save
        redirect_to grades_course_terms_path(@course),
                    notice: "Term was successfully created."
      else
        render :new
      end
    end

    def edit
      @course = find_course
      @term = find_term
    end

    def update
      @course = find_course
      @term = find_term

      if @term.update(term_params)
        redirect_to grades_course_terms_path(@course),
                    notice: "Term was successfully updated."
      else
        render :edit
      end
    end

    def destroy
      @term = find_term
      @term.destroy

      redirect_to grades_course_terms_path,
                  notice: "Term was successfully destroyed."
    end

    private

    def find_course
      Course.find(params[:course_id])
    end

    def term_params
      params.require(:term).permit(:name)
    end

    def find_term
      Term.find(params[:id])
    end
  end
end
