class DateTimeInput < SimpleForm::Inputs::DateTimeInput
  def input(wrapper_options = nil)
    if options[:type] == :datetime
      input_html_classes.unshift("datetimepicker")
    else
      input_html_classes.unshift("datepicker")
    end
    options.delete(:type)
    input_html_options[:type] = 'text'
    input_html_options[:placeholder] = 'simple_form.placeholders.datetime'.t

    s = "<div class='input-group'>"
    s << "<label class='input-group-addon' for='#{object_name}_#{attribute_name}'><i class='fa fa-calendar'></i></label>"
    s << @builder.text_field(attribute_name, input_html_options)
    s << "</div>"
    s
  end
end
