require "rails_helper"

RSpec.describe "Student EDA", type: :request do
  before do
    director = create(:user, :director)
    sign_in(director)
  end

  describe "GET /new" do
    it "render succesfully" do
      student = create(:student)

      get "/students/#{student.id}/student_edas/new"

      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    it "creates student EDA" do
      student = create(:student)

      post "/students/#{student.id}/student_edas",
           params: { student_eda: attributes_for(:student_eda) }

      eda = StudentEda.first
      expect(response).to have_http_status(:ok)
      expect(eda.student_code).not_to be_empty
    end
  end
end
