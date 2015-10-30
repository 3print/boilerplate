class MarkdownInput < SimpleForm::Inputs::TextInput
  def input(wrapper_options = nil)
    input_html_options['data-editor'] = 'markdown'
    input_html_options['data-iconlibrary'] = 'fa'
    input_html_options['data-language'] = I18n.locale
    input_html_options['data-resize'] = 'vertical'

    # merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

    @builder.text_area(attribute_name, input_html_options)
  end
end
