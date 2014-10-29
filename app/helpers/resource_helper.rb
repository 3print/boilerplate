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

  def resource_field_proc(label, &block)
    proc = Proc.new(&block)
    mod = Module.new do
      def to_s
        @label.to_s
      end

      def to_sym
        :"#{@label.to_s}"
      end
    end
    proc.send(:instance_variable_set, :@label, label)
    proc.send(:extend, mod)
    proc
  end

  def resource_label_proc
    resource_field_proc :resource_label do |item| resource_label_for item end
  end

  def resource_link_proc
    resource_field_proc :resource_label do |item|
      link_to resource_label_for(item), [item]
    end
  end

  def admin_resource_label_proc
    resource_field_proc :resource_label do |item|
      link_to resource_label_for(item), [:admin, item]
    end
  end

  def admin_resource_formats_proc
    resource_field_proc :resource_label do |item|
      item.formats.to_a.to_sentence
    end
  end

  def admin_templates_groups_proc
    resource_field_proc :templates_group do |item|
      link_to item.localized_name, [:admin, item]
    end
  end

  def admin_store_proc
    resource_field_proc :store do |item|
      link_to resource_label_for(item.store), [:admin, item.store]
    end
  end

  def masquerade_proc
    resource_field_proc :masquerade do |item|
      s = icon('sign-in')
      s += 'actions.masquerade'.t
      link_to s, user_masquerade_path(item), class: 'btn btn-warning btn-block'
    end
  end

  def resource_image_proc(size=nil)
    if size
      resource_field_proc :image do |item| image_tag item.image.send(size) end
    else
      resource_field_proc :image do |item| image_tag item.image end
    end
  end

  def resource_actions_proc(label, path)
    resource_field_proc :resource_label do |item|
      link_to label, path + [item]
    end
  end

  def resource_email_proc
    resource_field_proc :email do |item| mail_to item.email end
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
