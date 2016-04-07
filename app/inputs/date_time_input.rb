class DateTimeInput < SimpleForm::Inputs::DateTimeInput
  def input(wrapper_options = nil)
    type = options[:type] || column.type
    if type == :datetime
      input_html_classes.unshift("datetimepicker")
      input_html_options[:placeholder] = 'simple_form.placeholders.datetime'.t
    elsif type == :time
      input_html_classes.unshift("timepicker")
      input_html_options[:placeholder] = 'simple_form.placeholders.time'.t
    else
      input_html_classes.unshift("datepicker")
      input_html_options[:placeholder] = 'simple_form.placeholders.date'.t
    end
    options.delete(:type)
    input_html_options[:type] = 'text'

    s = "<div class='input-group'>"
    s << "<label class='input-group-addon' for='#{object_name}_#{attribute_name}'><i class='fa fa-calendar'></i></label>"
    s << @builder.text_field(attribute_name, input_html_options)
    s << "</div>"
    s
  end
end
