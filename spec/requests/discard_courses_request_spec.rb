require "rails_helper"

RSpec.describe "DiscardCourses", type: :request do
  describe "POST /discard" do
    it "discards course" do
      director = create(:user, :director)
      sign_in(director)
      course = create(:course)

      post "/courses/#{course.id}/discard"

      expect(course.reload.discarded?).to be(true)
    end
  end

  describe "POST /undiscard" do
    it "undiscards a discarded course" do
      director = create(:user, :director)
      sign_in(director)
      course = create(:course, :discarded)

      post "/courses/#{course.id}/undiscard"

      expect(course.reload.undiscarded?).to be(true)
    end
  end
end
