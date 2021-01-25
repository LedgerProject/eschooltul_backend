require "rails_helper"

RSpec.describe "LessonTypes", type: :request do
  valid_attributes = { name: "Exam" }

  invalid_attributes = { name: "" }

  new_attributes = { name: "Final exam" }

  describe "GET /" do
    it "renders view successfully" do
      teacher = create(:user, :teacher)
      course = create(:course, user: teacher)
      sign_in(teacher)

      get grades_course_lesson_types_path(course)

      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders view successfully" do
      teacher = create(:user, :teacher)
      course = create(:course, user: teacher)
      sign_in(teacher)

      get new_grades_course_lesson_type_path(course)

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
          post grades_course_lesson_types_path(course), params: { lesson_type: valid_attributes }
        end.to change(LessonType, :count).by(1)
      end

      it "redirects to index" do
        teacher = create(:user, :teacher)
        course = create(:course, user: teacher)
        sign_in(teacher)

        post grades_course_lesson_types_path(course), params: { lesson_type: valid_attributes }

        expect(response).to redirect_to grades_course_lesson_types_path(course)
      end
    end

    context "when it recieves invalid attributes" do
      it "doesn't create new record" do
        teacher = create(:user, :teacher)
        course = create(:course, user: teacher)
        sign_in(teacher)

        expect do
          post grades_course_lesson_types_path(course), params: { lesson_type: invalid_attributes }
        end.to change(LessonType, :count).by(0)
      end
    end
  end

  describe "GET /:id/edit" do
    it "renders view successfully" do
      teacher = create(:user, :teacher)
      course = create(:course, user: teacher)
      lesson_type = create(:lesson_type)
      sign_in(teacher)

      get edit_grades_course_lesson_type_path(course, lesson_type)

      expect(response).to be_successful
    end
  end

  describe "PATCH /:id" do
    context "when it recieves valid attributes" do
      it "updates a term record" do
        teacher = create(:user, :teacher)
        course = create(:course, user: teacher)
        lesson_type = create(:lesson_type)
        sign_in(teacher)

        patch grades_course_lesson_type_path(course, lesson_type),
              params: { lesson_type: new_attributes }

        lesson_type.reload
        expect(lesson_type.name).to eq(new_attributes[:name])
      end

      it "redirects to index" do
        teacher = create(:user, :teacher)
        course = create(:course, user: teacher)
        lesson_type = create(:lesson_type)
        sign_in(teacher)

        patch grades_course_lesson_type_path(course, lesson_type),
              params: { lesson_type: new_attributes }

        expect(response).to redirect_to grades_course_lesson_types_path(course)
      end
    end

    context "when it recieves invalid attributes" do
      it "doesn't change term record" do
        teacher = create(:user, :teacher)
        course = create(:course, user: teacher)
        lesson_type = create(:lesson_type)
        sign_in(teacher)

        patch grades_course_lesson_type_path(course, lesson_type),
              params: { lesson_type: invalid_attributes }

        updated_lesson_type = LessonType.find_by(id: lesson_type.id)
        expect(lesson_type.name).to eq(updated_lesson_type.name)
      end
    end
  end

  describe "DELETE /:id" do
    it "destroys a term record" do
      teacher = create(:user, :teacher)
      course = create(:course, user: teacher)
      lesson_type = create(:lesson_type)
      sign_in(teacher)

      expect do
        delete grades_course_lesson_type_path(course, lesson_type)
      end.to change(LessonType, :count).by(-1)
    end
  end
end
