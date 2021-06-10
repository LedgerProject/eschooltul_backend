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
          birthday: 10.years.from_now
        },
        {
          name: "Lisa",
          first_surname: "Simpson",
          birthday: 8.years.from_now
        },
        {
          name: "Nelson",
          first_surname: "Muntz",
          birthday: 10.years.from_now
        },
        {
          name: "Milhouse",
          first_surname: "Van Houten",
          birthday: 10.years.from_now
        },
        {
          name: "Ralph",
          first_surname: "Wiggum",
          birthday: 8.years.from_now
        },
        {
          name: "Martin",
          first_surname: "Prince",
          birthday: 10.years.from_now
        },
        {
          name: "Üter",
          first_surname: "Zörker",
          birthday: 8.years.from_now
        }
      ]
    )
  end
end
