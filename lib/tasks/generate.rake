namespace :generate do
  desc "Generate massive ammount of reports in DB"
  task :reports, %i[total] => :environment do
    args = Generate.parse_args

    puts "Generating student and course..."
    Generate.create_student_and_course
    student = Generate.find_student
    course = Generate.find_course

    reports = args[:total]
    puts "Generating #{reports} reports..."
    Report.delete_by(student:, course:)
    reports.times do |i|
      content = Base64.encode64(Generate.create_pdf)
      FactoryBot.create(:report,
        course:,
        student:,
        content:,
        date: Time.zone.today + i.day,
        content_hash: Digest::SHA256.hexdigest(content)
      )
    end
    exit
  end
end

class Generate
  TEST_NAME = "STRESS".freeze
  ACTION_CONTROLLER = ActionController::Base.new

  def self.parse_args
    options = { total: 1_000 }
    opts = OptionParser.new
    opts.banner = "Usage: generate:reports [options]"
    opts.on("-t ARG", "--total ARG", Integer, "Total reports to create") { |v| options[:total] = v }
    opts.on("-h", "--help", "Show commands") do
      puts opts
      exit
    end
    args = opts.order!(ARGV) {}
    opts.parse!(args)
    options
  end

  def self.create_student_and_course
    FactoryBot.create(:student, name: TEST_NAME) if Generate.find_student.blank?
    FactoryBot.create(:course, name: TEST_NAME) if Generate.find_course.blank?
  end

  def self.find_course
    Course.find_by(name: TEST_NAME)
  end

  def self.find_student
    Student.find_by(name: TEST_NAME)
  end

  def self.find_school
    School.first
  end

  def self.pdf_data
    {
      student: Generate.find_student,
      course: Generate.find_course,
      school: Generate.find_school,
      mark_value: rand(0.0...10.0)
    }
  end

  def self.create_pdf
    pdf_string = ACTION_CONTROLLER.render_to_string(
      template: "report/show",
      encoding: "UTF-8",
      locals: Generate.pdf_data
    )
    WickedPdf.new.pdf_from_string(pdf_string)
  end
end
