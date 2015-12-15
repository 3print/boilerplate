module ResourceProcHelper
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

  def resource_actions_proc(*actions)
    def resolve_url(action, item)
      base = controller.is_admin? ? [:admin] : []
      case action.to_s
      when 'update' then base + [item]
      when 'create' then base + [item.class]
      when 'index' then base + [item.class]
      when 'destroy' then base + [item]
      when 'show' then base + [item]
      when 'new' then [:new] + base + [singular]
      else
        [action.to_sym] + base + [item]
      end
    end

    resource_field_proc :actions do |item|
      "<div class='btn-group'>#{actions.map do |a|
        if a.is_a?(Hash)
          a.map do |k,v|
            if can? k, item
              label = icon_and_text("actions.#{k}".t, icon_class_for(k))

              if v.is_a?(Hash)
                link_to label, resolve_url(k, item), {class: "btn btn-#{classname_for_action(k)}"}.merge(v)
              elsif v.is_a?(Symbol)
                link_to label, send(v, item), {class: "btn btn-#{classname_for_action(k)}"}
              else
                link_to label, v, {class: "btn btn-#{classname_for_action(k)}"}
              end
            end
          end
        else
          if can? a, item
            label = icon_and_text("actions.#{a}".t, icon_class_for(a))
            link_to label, resolve_url(a, item), class: "btn btn-#{classname_for_action(a)}"
          end
        end
      end.flatten.compact.join
      }</div>".html_safe
    end
  end

  def masquerade_proc
    resource_field_proc :masquerade do |item|
      s = icon('user-secret')
      s += "<span class='text'>#{'actions.masquerade'.t}</span>".html_safe
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

  def resource_email_proc
    resource_field_proc :email do |item| mail_to item.email end
  end

  def resource_phone_proc
    resource_field_proc :phone do |item|
      link_to phone_number(item.phone), "tel:#{item.phone}"
    end
  end

  def resource_user_card_proc
    resource_field_proc :user_card do |item|
      render partial: 'shared/user_card', locals: {user: item}
    end
  end
end
