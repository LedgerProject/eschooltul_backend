class StressController < ApplicationController
  skip_before_action :verify_authenticity_token
  http_basic_authenticate_with name: Rails.application.credentials.stress[:user],
                               password: Rails.application.credentials.stress[:password]

  def create
    command = "rake stress:apiroom --"\
              "#{generate_task_param('file', file_name)}"\
              "#{generate_task_param('rps', params[:rps])}"\
              "#{generate_task_param('time', params[:time])}"\
              "#{generate_task_param('fake', params[:fake])}"\

    Thread.new { system(command) }
    render plain: "Task created, files will be named #{file_name} #{command}"
  end

  private

  def file_name
    "result_#{Time.now.to_i}"
  end

  def generate_task_param(key, param)
    " --#{key} #{param}" if param.present?
  end
end
