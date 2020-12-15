require "rails_helper"

RSpec.describe "/students", type: :request do
  # TODO: better to create test state inline
  before do
    director = create(:user, :director)
    sign_in(director)
  end

  describe "GET /index" do
    it "renders a successful response" do
      create(:student)

      get students_url

      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      student = create(:student)

      get student_url(student)

      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_student_url

      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "render a successful response" do
      student = create(:student)

      get edit_student_url(student)

      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Student" do
        expect do
          post students_url, params: { student: attributes_for(:student) }
        end.to change(Student, :count).by(1)
      end

      it "redirects to the created student" do
        post students_url, params: { student: attributes_for(:student) }
        expect(response).to redirect_to(student_url(Student.last))
      end
    end
  end

  describe "POST /deactivate" do
    it "deactivates a student" do
      student = create(:student)

      post "/students/#{student.id}/deactivate"

      student.reload
      expect(student.deactivated).to be(true)
    end

    context "when is deactivated" do
      it "activates a student" do
        student = create(:student, :deactivated)

        post "/students/#{student.id}/deactivate"

        student.reload
        expect(student.deactivated).to be(false)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested student" do
      student = create(:student)

      expect do
        delete student_url(student)
      end.to change(Student, :count).by(-1)
    end

    it "redirects to the students list" do
      student = create(:student)

      delete student_url(student)

      expect(response).to redirect_to(students_url)
    end
  end
end
