# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_06_15_144956) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "course_students", force: :cascade do |t|
    t.bigint "course_id", null: false
    t.bigint "student_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["course_id"], name: "index_course_students_on_course_id"
    t.index ["student_id"], name: "index_course_students_on_student_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "name"
    t.string "subject"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_courses_on_discarded_at"
    t.index ["subject", "name"], name: "index_courses_on_subject_and_name", unique: true
    t.index ["user_id"], name: "index_courses_on_user_id"
  end

  create_table "document_reports", force: :cascade do |t|
    t.text "content"
    t.string "content_hash"
    t.string "transaction_id"
    t.bigint "student_id"
    t.date "date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["student_id"], name: "index_document_reports_on_student_id"
  end

  create_table "lesson_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "lessons", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.text "grading_method"
    t.bigint "lesson_type_id"
    t.bigint "course_id", null: false
    t.bigint "term_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["course_id"], name: "index_lessons_on_course_id"
    t.index ["lesson_type_id"], name: "index_lessons_on_lesson_type_id"
    t.index ["term_id"], name: "index_lessons_on_term_id"
  end

  create_table "marks", force: :cascade do |t|
    t.decimal "value"
    t.bigint "student_id", null: false
    t.string "remarkable_type", null: false
    t.bigint "remarkable_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["remarkable_type", "remarkable_id"], name: "index_marks_on_remarkable_type_and_remarkable_id"
    t.index ["student_id"], name: "index_marks_on_student_id"
  end

  create_table "reports", force: :cascade do |t|
    t.text "content"
    t.string "content_hash"
    t.string "transaction_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "student_id"
    t.bigint "course_id"
    t.date "date"
    t.index ["content_hash"], name: "index_reports_on_content_hash", unique: true
    t.index ["student_id", "course_id", "date"], name: "unique_report_index", unique: true
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource_type_and_resource_id"
  end

  create_table "schools", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "address"
    t.string "city"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "student_edas", force: :cascade do |t|
    t.string "student_code"
    t.string "mode_of_study"
    t.string "mode_of_delivery"
    t.string "language"
    t.string "email_address"
    t.date "certification_date"
    t.string "course_unit_type"
    t.date "date"
    t.string "ECTS_grading_scale_type"
    t.string "national_framework_qualifications"
    t.decimal "percent", precision: 3, scale: 2
    t.string "source_grade"
    t.bigint "student_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "country"
    t.integer "year_of_study"
    t.string "framework_code"
    t.string "group_identifier"
    t.string "institution_identifier"
    t.string "suplement_language"
    t.string "gender"
    t.string "source_course_code"
    t.integer "number_of_years"
    t.index ["student_id"], name: "index_student_edas_on_student_id"
  end

  create_table "students", force: :cascade do |t|
    t.string "name"
    t.string "first_surname"
    t.string "second_surname"
    t.string "telephone"
    t.string "diseases"
    t.text "observations"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "deactivated", default: false
    t.date "birthday"
    t.string "city"
    t.string "state_or_region"
    t.string "postal_code"
    t.string "country"
    t.index ["deactivated"], name: "index_students_on_deactivated"
  end

  create_table "terms", force: :cascade do |t|
    t.string "name"
    t.bigint "course_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["course_id"], name: "index_terms_on_course_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.string "first_surname"
    t.string "second_surname"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "course_students", "courses"
  add_foreign_key "course_students", "students"
  add_foreign_key "courses", "users"
  add_foreign_key "lessons", "courses"
  add_foreign_key "lessons", "lesson_types"
  add_foreign_key "lessons", "terms"
  add_foreign_key "marks", "students"
  add_foreign_key "reports", "courses"
  add_foreign_key "reports", "students"
  add_foreign_key "student_edas", "students"
  add_foreign_key "terms", "courses"
end
