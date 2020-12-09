if Rails.env.development?
  EMAILS = %w[
    mario.perez@exponentiateam.com
    joaquin.martinez@exponentiateam.com
  ].freeze

  EMAILS.each do |email|
    next if User.exists?(email: email)

    User.create!(email: email, password: "password", password_confirmation: "password")
  end
end
