require "rails_helper"

RSpec.describe "Reports", type: :request do
  describe "Report#show" do
    it "creates report", :vcr do
      director = create(:user, :director)
      sign_in(director)
      student = create(:student)
      mark = create(:mark, :with_course, student: student)
      course = mark.remarkable

      get "/report/#{student.id}.pdf?course_id=#{course.id}"

      report = Report.first
      expect(response).to have_http_status(:ok)
      expect(report.content).not_to be_empty
      expect(report.content_hash).not_to be_empty
      expect(report.course).to eq(course)
    end

    context "when report is already created the same day" do
      it "doesn't create a new one" do
        director = create(:user, :director)
        sign_in(director)
        student = create(:student)
        mark = create(:mark, :with_course, student: student)
        course = mark.remarkable
        create(:report, course: course, student: student, date: Time.zone.today)

        get "/report/#{student.id}.pdf?course_id=#{course.id}"

        expect(response).to have_http_status(:ok)
        expect(Report.count).to eq(1)
      end
    end

    context "when generating a report without marks" do
      it "doesn't generate report" do
        director = create(:user, :director)
        sign_in(director)
        course = create(:course)
        student = create(:student)
        student.courses << course

        get "/report/#{student.id}.pdf?course_id=#{course.id}"

        expect(response).to have_http_status(:redirect)
        expect(flash[:alert]).to eq("Must put marks before generating the report.")
        expect(Report.count).to eq(0)
      end
    end
  end
end
