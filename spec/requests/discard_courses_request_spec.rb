require "rails_helper"

RSpec.describe "DiscardCourses", type: :request do
  describe "courses#discard" do
    it "course is discarded" do
      director = create(:user, :director)
      sign_in(director)
      course = create(:course)

      post "/courses/#{course.id}/discard"

      expect(response).to redirect_to courses_path
      expect(flash[:notice]).to eq("Course was successfully discarded")
    end
  end

  describe "courses#undiscard" do
    it "course is undiscarded" do
      director = create(:user, :director)
      sign_in(director)
      course = create(
        :course,
        discarded_at: Time.zone.now
      )

      post "/courses/#{course.id}/undiscard"

      expect(response).to redirect_to discard_courses_path
      expect(flash[:notice]).to eq("Course was successfully undiscarded")
    end
  end
end
