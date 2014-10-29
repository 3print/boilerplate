module ApplicationHelper
  def current_controller? name
    controller_name.to_s == name.to_s
  end
end
