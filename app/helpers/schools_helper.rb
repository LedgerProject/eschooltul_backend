module SchoolsHelper
  def blank_or_nil(data, default_value)
    if data.nil? || data.blank?
      default_value
    else
      data
    end
  end
end
