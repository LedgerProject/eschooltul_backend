require "rails_helper"

RSpec.describe "Courses", type: :request do
  describe "GET /courses" do
    context "when user is a teacher" do
      it "can't access" do
        teacher = create(:user, :teacher)
        sign_in(teacher)
        create(:course)

        get "/courses"

        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "POST /:id/duplicate" do
    it "duplicates course with students" do
      director = create(:user, :director)
      sign_in(director)
      course = create(:course)
      course.students << create(:student)

      post "/courses/#{course.id}/duplicate"

      duplicated_course = Course.last!
      expect(Course.count).to eq(2)
      expect(duplicated_course.subject).to eq("#{course.subject} (Duplicate)")
      expect(duplicated_course.students.count).to eq(1)
    end
  end
end
