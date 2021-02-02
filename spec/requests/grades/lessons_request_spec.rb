require "rails_helper"

RSpec.describe "Lessons", type: :request do
  def valid_attributes(lesson_type_id, term_id = nil)
    {
      name: "Math exercises",
      description: "Do math additions",
      grading_method: "Chek if they now how to add numbers",
      lesson_type_id: lesson_type_id,
      term_id: term_id
    }
  end

  invalid_attributes = {
    name: "Math exercises",
    description: "Do math additions",
    grading_method: "Chek if they now how to add numbers",
    lesson_type_id: nil,
    term_id: nil
  }

  def new_attributes(lesson)
    {
      name: "Math exercises 2",
      description: "Do math additions",
      grading_method: "Chek if they now how to add numbers",
      lesson_type_id: lesson.lesson_type.id,
      term_id: lesson.term.id
    }
  end

  describe "GET /" do
    it "renders view successfully" do
      teacher = create(:user, :teacher)
      course = create(:course, user: teacher)
      sign_in(teacher)

      get grades_course_lessons_path(course_id: course.id)

      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders view successfully" do
      teacher = create(:user, :teacher)
      course = create(:course, user: teacher)
      sign_in(teacher)

      get new_grades_course_lesson_path(course_id: course.id)

      expect(response).to be_successful
    end
  end

  describe "POST /" do
    context "when it recieves valid attributes" do
      it "creates a new lesson record without term" do
        teacher = create(:user, :teacher)
        course = create(:course, user: teacher)
        lesson_type = create(:lesson_type)
        sign_in(teacher)

        expect do
          post grades_course_lessons_path(course_id: course.id),
               params: { lesson: valid_attributes(lesson_type.id) }
        end.to change(Lesson, :count).by(1)
      end

      it "creates a new lesson record with term" do
        teacher = create(:user, :teacher)
        course = create(:course, user: teacher)
        lesson_type = create(:lesson_type)
        term = create(:term, course: course)
        sign_in(teacher)

        expect do
          post grades_course_lessons_path(course_id: course.id),
               params: { lesson: valid_attributes(lesson_type.id, term.id) }
        end.to change(Lesson, :count).by(1)
      end

      it "redirects to index" do
        teacher = create(:user, :teacher)
        course = create(:course, user: teacher)
        lesson_type = create(:lesson_type)
        term = create(:term, course: course)
        sign_in(teacher)

        post grades_course_lessons_path(course_id: course.id),
             params: { lesson: valid_attributes(lesson_type.id, term.id) }

        expect(response).to redirect_to grades_course_lessons_path(course)
      end
    end

    context "when it recieves invalid attributes" do
      it "doesn't create new record" do
        teacher = create(:user, :teacher)
        course = create(:course, user: teacher)
        sign_in(teacher)

        expect do
          post grades_course_lessons_path(course_id: course.id),
               params: { lesson: invalid_attributes }
        end.to change(Lesson, :count).by(0)
      end
    end
  end

  describe "GET /:id/edit" do
    it "renders view successfully" do
      teacher = create(:user, :teacher)
      course = create(:course, user: teacher)
      lesson = create(:lesson, course: course)
      sign_in(teacher)

      get edit_grades_course_lesson_path(course_id: course.id, id: lesson.id)

      expect(response).to be_successful
    end
  end

  describe "PATCH /:id" do
    context "when it recieves valid attributes" do
      it "updates a lesson record" do
        teacher = create(:user, :teacher)
        course = create(:course, user: teacher)
        lesson = create(:lesson, course: course)
        sign_in(teacher)
        new_attributes = new_attributes(lesson)

        patch grades_course_lesson_path(course_id: course.id, id: lesson.id),
              params: { lesson: new_attributes }

        lesson.reload
        expect(lesson.name).to eq(new_attributes[:name])
      end

      it "redirects to index" do
        teacher = create(:user, :teacher)
        course = create(:course, user: teacher)
        lesson = create(:lesson, course: course)
        sign_in(teacher)

        patch grades_course_lesson_path(course_id: course.id, id: lesson.id),
              params: { lesson: new_attributes(lesson) }

        expect(response).to redirect_to grades_course_lessons_path(course)
      end
    end

    context "when it recieves invalid attributes" do
      it "doesn't change term record" do
        teacher = create(:user, :teacher)
        course = create(:course, user: teacher)
        lesson = create(:lesson, course: course)
        sign_in(teacher)

        patch grades_course_lesson_path(course_id: course.id, id: lesson.id),
              params: { lesson: invalid_attributes }

        updated_lesson = Lesson.find_by(id: lesson.id)
        expect(lesson.name).to eq(updated_lesson.name)
      end
    end
  end

  describe "DELETE /:id" do
    it "destroys a term record" do
      teacher = create(:user, :teacher)
      course = create(:course, user: teacher)
      lesson = create(:lesson, course: course)
      sign_in(teacher)

      expect do
        delete grades_course_lesson_path(course_id: course.id, id: lesson.id)
      end.to change(Lesson, :count).by(-1)
    end
  end
end
