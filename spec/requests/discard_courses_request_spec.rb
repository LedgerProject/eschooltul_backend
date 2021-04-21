require "rails_helper"

RSpec.describe "DiscardCourses", type: :request do
  describe "POST /discard" do
    it "discards course" do
      director = create(:user, :director)
      sign_in(director)
      course = create(:course)

      post "/courses/#{course.id}/discard"

      expect(response).to redirect_to courses_path
      expect(flash[:notice]).to eq("Course was successfully discarded")
      expect(course.reload.discarded?).to be(true)
    end
  end

  describe "POST /undiscard" do
    it "undiscards a discarded course" do
      director = create(:user, :director)
      sign_in(director)
      course = create(:course, :discarded)

      post "/courses/#{course.id}/undiscard"

      expect(response).to redirect_to discard_courses_path
      expect(flash[:notice]).to eq("Course was successfully undiscarded")
      expect(course.reload.undiscarded?).to be(true)
    end
  end
end
