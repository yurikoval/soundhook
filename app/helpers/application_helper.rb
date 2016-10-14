module ApplicationHelper
  def locations
    (ENV['LOCATIONS'] || '').split(',') + [default_path]
  end
end
