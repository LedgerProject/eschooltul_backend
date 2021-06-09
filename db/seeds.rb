Role::NAMES.each do |name|
  Role.find_or_create_by!(name: name)
end

if User.count.zero?
  director = User.create!(
    email: "skinner@springfieldelementaryschool.com",
    password: "password",
    password_confirmation: "password"
  )
  director.add_role(:director)
end

School.create!(name: "Springfield Elementary School") unless School.created?

if Rails.env.development?
  ADMINISTRATORS = %w[
    joaquin.martinez@exponentiateam.com
  ].freeze

  TEACHERS = %w[
    mario.perez@exponentiateam.com
  ].freeze

  ADMINISTRATORS.each do |email|
    next if User.exists?(email: email)

    user = User.create!(email: email, password: "password", password_confirmation: "password")
    user.add_role(:administrator)
  end

  TEACHERS.each do |email|
    next if User.exists?(email: email)

    user = User.create!(email: email, password: "password", password_confirmation: "password")
    user.add_role(:teacher)
  end

  if Student.count.zero?
    Student.create!(
      [
        {
          name: "Bart",
          first_surname: "Simpson",
          birthday: DateTime.new(2011, 1, 1)
        },
        {
          name: "Lisa",
          first_surname: "Simpson",
          birthday: DateTime.new(2013, 1, 1)
        },
        {
          name: "Nelson",
          first_surname: "Muntz",
          birthday: DateTime.new(2011, 1, 1)
        },
        {
          name: "Milhouse",
          first_surname: "Van Houten",
          birthday: DateTime.new(2011, 1, 1)
        },
        {
          name: "Ralph",
          first_surname: "Wiggum",
          birthday: DateTime.new(2013, 1, 1)
        },
        {
          name: "Martin",
          first_surname: "Prince",
          birthday: DateTime.new(2013, 1, 1)
        },
        {
          name: "Üter",
          first_surname: "Zörker",
          birthday: DateTime.new(2013, 1, 1)
        }
      ]
    )
  end
end
