module ApplicationHelper
  def current_controller? name
    controller_name.to_s == name.to_s
  end

  def in_admin &block
    if controller.class.name =~ /^admin::/i
      if block_given?
        yield
      end
    end
  end
end
