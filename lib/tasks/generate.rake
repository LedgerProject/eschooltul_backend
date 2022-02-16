namespace :generate do
  desc "Generate massive ammount of reports in DB"
  task :reports, %i[courses students] => :environment do
    args = Generate.parse_args

    puts "Clearing dataset..."
    Generate.clear_dataset

    puts "Creating new dataset with #{args[:courses]} courses, "\
         "#{args[:students]} students per course with reports "
    Generate.create_dataset(args[:courses], args[:students])

    puts "Total reports created: #{Report.count}"
    exit
  end
end

class Generate
  ACTION_CONTROLLER = ActionController::Base.new

  def self.parse_args
    options = { courses: 100, students: 25 }
    opts = OptionParser.new
    opts.banner = "Usage: generate:reports [options]"
    opts.on("-c ARG", "--courses ARG", Integer, "Total courses to create") do |v|
      options[:courses] = v
    end
    opts.on("-s ARG", "--students ARG", Integer, "Total students to create per course with reports") do |v|
      options[:students] = v
    end
    opts.on("-h", "--help", "Show commands of this rake task") do
      puts opts
      exit
    end
    args = opts.order!(ARGV) {}
    opts.parse!(args)
    options
  end

  def self.clear_dataset
    puts "Deleting schools..."
    School.delete_all
    puts "Deleting reports..."
    Report.delete_all
    puts "Deleting relations course-student..."
    CourseStudent.delete_all
    puts "Deleting marks..."
    Mark.delete_all
    puts "Deleting courses..."
    Course.delete_all
    puts "Deleting students..."
    Student.delete_all
    puts "Deleting users..."
    User.delete_all
  end

  def self.create_dataset(courses, students)
    school = create_school
    puts "School created: #{school.name}"
    user = create_user
    puts "User created: #{user.name}"
    courses.times do
      course = create_course(user)
      puts "Course created: #{course.name} - #{course.subject}"
      students.times do
        student = create_student(course)
        puts "\tStudent created: #{student.name} #{student.first_surname}"
        mark = create_mark(course, student)
        puts "\t\tMark created: #{mark.value}"
        report = create_report(course, student, mark)
        puts "\t\tReport created: #{report.content_hash}"
      end
    end
  end

  def self.create_school
    FactoryBot.create(:school,
                      name: Faker::Educator.secondary_school,
                      email: Faker::Internet.email,
                      city: Faker::Address.city,
                      address: Faker::Address.street_address)
  end

  def self.create_user
    FactoryBot.create(:user, :director, email: Faker::Internet.email)
  end

  def self.create_course(user)
    FactoryBot.create(:course,
                      user:,
                      subject: Faker::Educator.subject,
                      name: Faker::Educator.course_name)
  end

  def self.create_student(course)
    student = FactoryBot.create(:student,
                                first_surname: Faker::Name.last_name,
                                second_surname: "",
                                name: Faker::Name.first_name,
                                diseases: "",
                                observations: "",
                                telephone: Faker::PhoneNumber.cell_phone_in_e164,
                                city: Faker::Address.city,
                                state_or_region: Faker::Address.state,
                                postal_code: Faker::Address.zip_code,
                                country: Faker::Address.country,
                                birthday: Faker::Time.between(from: DateTime.now - 18.years,
                                                              to: DateTime.now - 10.years))
    student.courses << course
    student
  end

  def self.create_mark(course, student)
    FactoryBot.create(:mark,
                      remarkable: course,
                      student:,
                      value: Faker::Number.between(from: 0.0, to: 10.0).round(1))
  end

  def self.create_report(course, student, mark)
    content = Base64.encode64(create_pdf(course, student, mark))
    FactoryBot.create(:report,
                      course:,
                      student:,
                      content:,
                      date: Faker::Time.unique.between(from: DateTime.now - 1.year,
                                                       to: DateTime.now),
                      content_hash: Digest::SHA256.hexdigest(content))
  end

  def self.create_pdf(course, student, mark)
    pdf_string = ACTION_CONTROLLER.render_to_string(
      template: "report/show",
      encoding: "UTF-8",
      locals: {
        student:,
        course:,
        school: School.first,
        mark_value: mark.value
      }
    )
    WickedPdf.new.pdf_from_string(pdf_string)
  end
end
