EnumHelp::Helper.class_eval do
  def self.translate_enum_label(klass, attr_name, enum_label)
    if enum_label.is_a?(Array)
      enum_label.map do |e|
        enum_i18n_key(klass, attr_name, e).t(default: e.humanize)
      end
    else
      enum_i18n_key(klass, attr_name, enum_label).t(default: enum_label.humanize)
    end
  end

  def self.enum_i18n_key(klass, attr_name, enum_label)
    "enums.#{klass.to_s.underscore.gsub('/', '.')}.#{attr_name}.#{enum_label}"
  end
end

EnumHelp::SimpleForm::EnumInput.class_eval do
  def input_html_classes
    super.push('form-select')
  end
end
