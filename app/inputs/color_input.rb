class ColorInput < SimpleForm::Inputs::TextInput
  def input(wrapper_options = nil)
    input_html_classes.unshift("color")
    input_html_options[:type] = 'color'
    input_html_options[:placeholder] = 'simple_form.placeholders.color'.t

    s = "<div class='input-group'>"
    s << "<span class='input-group-addon'><i class='fa fa-paint-brush'></i></span>"
    s << @builder.text_field(attribute_name, input_html_options)
    s << "</div>"
    s
  end
end
