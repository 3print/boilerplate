class DateTimeInput < SimpleForm::Inputs::DateTimeInput
  def input(wrapper_options = nil)
    type = options[:type] || column.type
    s = "<div class='input-group'>"

    if type == :datetime
      s << "<label class='input-group-text' for='#{object_name}_#{attribute_name}'>#{Feather[:calendar]}</label>"
      type = 'datetime-local'
      value = object.send(attribute_name)

      input_html_classes.unshift("datetimepicker")

      input_html_options[:type] = :date
      input_html_options[:placeholder] = 'simple_form.placeholders.date'.t
      input_html_options[:value] = value.present? ? value.to_formatted_s(:iso8601).split('T')[0] : nil
      s << @builder.text_field("#{attribute_name}__date", input_html_options)

      input_html_options[:type] = :time
      input_html_options[:placeholder] = 'simple_form.placeholders.time'.t
      value.present? ? input_html_options[:value] = value.to_formatted_s(:time) : nil
      s << @builder.text_field("#{attribute_name}__time", input_html_options)

      s << @builder.hidden_field("#{attribute_name}__offset", {
        value: (value || Time.now).to_formatted_s(:iso8601).split('+').last,
      })

    elsif type == :time
      s << "<label class='input-group-text' for='#{object_name}_#{attribute_name}'>#{Feather[:clock]}</label>"
      input_html_classes.unshift("timepicker")
      input_html_options[:placeholder] = 'simple_form.placeholders.time'.t
      s << @builder.text_field(attribute_name, input_html_options)
    else
      s << "<label class='input-group-text' for='#{object_name}_#{attribute_name}'>#{Feather[:calendar]}</label>"
      input_html_options[:type] = type
      input_html_classes.unshift("datepicker")
      input_html_options[:placeholder] = 'simple_form.placeholders.date'.t
      s << @builder.text_field(attribute_name, input_html_options)
    end
    # options.delete(:type)

    s << "</div>"
    s
  end
end
