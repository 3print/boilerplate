module ResourceHelper
  def resource
    controller.resource
  end

  def resource_collection
    controller.resource
  end

  def resource_class
    controller.resource_class
  end

  def resource_label_for resource
    if resource.respond_to?(:caption) && resource.caption.present?
      label = resource.caption
    elsif resource.respond_to?(:localized_name) && resource.name.present?
      label = resource.localized_name
    elsif resource.respond_to?(:name) && resource.name.present?
      label = resource.name
    elsif resource.respond_to?(:title) && resource.title.present?
      label = resource.title
    end
    label = resource.to_s if label.nil?
    label
  end

  def resource_label
    resource_label_for resource
  end
end
