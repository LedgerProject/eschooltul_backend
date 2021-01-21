require "rails_helper"

RSpec.describe "Terms", type: :request do
  valid_attributes = { name: "First trimester" }

  invalid_attributes = { name: "" }

  new_attributes = { name: "Second trimester" }

  describe "GET /" do
    it "renders view successfully" do
      teacher = create(:user, :teacher)
      course = create(:course, user: teacher)
      sign_in(teacher)

      get grades_course_terms_path(course)

      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders view successfully" do
      teacher = create(:user, :teacher)
      course = create(:course, user: teacher)
      sign_in(teacher)

      get new_grades_course_term_path(course)

      expect(response).to be_successful
    end
  end

  describe "POST /" do
    context "when it recieves valid attributes" do
      it "creates a new term record" do
        teacher = create(:user, :teacher)
        course = create(:course, user: teacher)
        sign_in(teacher)

        expect do
          post grades_course_terms_path(course), params: { term: valid_attributes }
        end.to change(Term, :count).by(1)
      end

      it "redirects to index" do
        teacher = create(:user, :teacher)
        course = create(:course, user: teacher)
        sign_in(teacher)

        post grades_course_terms_path(course), params: { term: valid_attributes }

        expect(response).to redirect_to grades_course_terms_path(course)
      end
    end

    context "when it recieves invalid attributes" do
      it "doesn't create new record" do
        teacher = create(:user, :teacher)
        course = create(:course, user: teacher)
        sign_in(teacher)

        expect do
          post grades_course_terms_path(course), params: { term: invalid_attributes }
        end.to change(Term, :count).by(0)
      end
    end
  end

  describe "GET /:id/edit" do
    it "renders view successfully" do
      teacher = create(:user, :teacher)
      course = create(:course, user: teacher)
      term = create(:term, course: course)
      sign_in(teacher)

      get edit_grades_course_term_path(course, term)

      expect(response).to be_successful
    end
  end

  describe "PATCH /:id" do
    context "when it recieves valid attributes" do
      it "updates a term record" do
        teacher = create(:user, :teacher)
        course = create(:course, user: teacher)
        term = create(:term, course: course)
        sign_in(teacher)

        patch grades_course_term_path(course, term), params: { term: new_attributes }

        term.reload
        expect(term.name).to eq(new_attributes[:name])
      end

      it "redirects to index" do
        teacher = create(:user, :teacher)
        course = create(:course, user: teacher)
        term = create(:term, course: course)
        sign_in(teacher)

        patch grades_course_term_path(course, term), params: { term: new_attributes }

        expect(response).to redirect_to grades_course_terms_path(course)
      end
    end

    context "when it recieves invalid attributes" do
      it "doesn't change term record" do
        teacher = create(:user, :teacher)
        course = create(:course, user: teacher)
        term = create(:term, course: course)
        sign_in(teacher)

        patch grades_course_term_path(course, term), params: { term: invalid_attributes }

        updated_term = Term.find_by(id: term.id)
        expect(term.name).to eq(updated_term.name)
      end
    end
  end

  describe "DELETE /:id" do
    it "destroys a term record" do
      teacher = create(:user, :teacher)
      course = create(:course, user: teacher)
      term = create(:term, course: course)
      sign_in(teacher)

      expect do
        delete grades_course_term_path(course, term)
      end.to change(Term, :count).by(-1)
    end
  end
end
