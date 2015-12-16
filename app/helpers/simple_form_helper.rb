module SimpleFormHelper
  def initialize(*args)
    super *args

    SimpleForm::FormBuilder.send(:include, form_user_mixin)
  end

  def form_user_mixin
    user = current_user
    # ability = current_ability

    form_user_mixin = Module.new
    form_user_mixin.send(:define_method, :current_user) { user }
    # form_user_mixin.send(:define_method, :current_ability) { ability }

    form_user_mixin
  end

  # Form Actions Helper

  def default_actions(options={}, &block)
    capture_haml do
      haml_tag 'div', class: 'panel-footer' do
        haml_tag 'fieldset', class: 'form-actions' do
          haml_tag 'button', class: "btn btn-success #{options[:class]}" do
            haml_tag 'span', class: icon_class(options[:icon] || 'check')
            haml_concat options[:submit] || "actions.submit".t
          end

          haml_concat capture_haml(&block) if block_given?

          if request.referrer && !options[:no_cancel]
            haml_tag 'a', href: request.referrer, class: "btn btn-danger #{options[:class]}" do
              haml_tag 'span', class: icon_class(options[:cancel_icon] || 'times')
              haml_concat options[:cancel] || 'actions.cancel'.t
            end
          end
        end
      end
    end
  end

  def each_field(model, &block)
    default_columns_for_object(model).each(&block)
  end

  # Automatic Form Generation Helper

  def inputs_for(model, form_builder)
    cols = []
    cols += content_columns(model)
    cols -= skipped_columns
    cols -= model.class::SKIPPED_COLUMNS.map(&:intern) if model.class::SKIPPED_COLUMNS.present? rescue false
    cols += model.class::EXTRA_COLUMNS.map(&:intern) if model.class::EXTRA_COLUMNS.present? rescue false

    cols.compact

    res = ''
    cols.each do |col|
      col_type = model.get_column_display_type(col)
      field_partial = "application/input_#{col_type}"
      admin_field_partial = "admin/application/input_#{col_type}"
      if partial_exist?(admin_field_partial)
        res << render(partial: admin_field_partial, locals: { model: model, col: col, form: form_builder }).to_s
      elsif partial_exist?(field_partial)
        res << render(partial: field_partial, locals: { model: model, col: col, form: form_builder }).to_s
      elsif col_type.present?
        res << form_builder.input(col, as: col_type, label: "#{model.class.name.underscore}.#{col}".tmf)
      else
        res << form_builder.input(col, label: "#{model.class.name.underscore}.#{col}".tmf)
      end
    end

    cols = association_columns(model, :belongs_to)
    cols -= SKIPPED_COLUMNS
    cols -= model.class::SKIPPED_COLUMNS.map(&:intern) if model.class::SKIPPED_COLUMNS.present? rescue false
    cols.each do |col|
      val = instance_variable_get("@#{col}") rescue nil
      if val
        res << form_builder.hidden_field(model.class.reflections[col].foreign_key, value: val.id)
      else
        res << form_builder.association(col, label: "#{model.class.name.underscore}.#{col}".tmf)
      end
    end

    res.html_safe
  end
end
