Role::NAMES.each do |name|
  Role.find_or_create_by!(name: name)
end

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
end
