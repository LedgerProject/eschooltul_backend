require "rails_helper"

RSpec.describe "Reports", type: :request do
  # TODO: move controller action to Report#create
  describe "Grades#show" do
    it "creates report", :vcr do
      director = create(:user, :director)
      sign_in(director)
      student = create(:student)
      mark = create(:mark, :with_course, student: student)
      course = mark.remarkable

      get "/grades/#{student.id}.pdf?course_id=#{course.id}"

      report = Report.first
      expect(response).to have_http_status(:ok)
      expect(report.content).not_to be_empty
      expect(report.content_hash).not_to be_empty
      expect(report.course).to eq(course)
    end
  end
end
