if defined?(CypressOnRails)
  CypressOnRails.configure do |c|
    c.cypress_folder = File.expand_path("#{__dir__}/../../spec/cypress")
    c.use_middleware = Rails.env.test?
    c.logger = Rails.logger
  end
end
