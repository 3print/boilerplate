class MarkdownInput < SimpleForm::Inputs::TextInput
  def input(wrapper_options = nil)
    input_html_options['data-editor'] = 'markdown'
    input_html_options['data-iconlibrary'] = 'fa'
    input_html_options['data-language'] = I18n.locale
    input_html_options['data-resize'] = 'vertical'

    html = '<div class="toolbar mb-2">'

    html << '<div class="btn-group me-2">'

    html << @builder.button(:button, Feather[:bold], class: 'btn btn-outline-secondary btn-sm btn-icon', data: {wrap: '**|**', keystroke: 'ctrl-b'})
    html << @builder.button(:button, Feather[:italic], class: 'btn btn-outline-secondary btn-sm btn-icon', data: {wrap: '*|*', keystroke: 'ctrl-i'})
    html << @builder.button(:button, Feather[:underline], class: 'btn btn-outline-secondary btn-sm btn-icon', data: {wrap: '__|__', keystroke: 'ctrl-u'})

    html << '</div>'

    html << '<div class="btn-group me-2">'

    html << @builder.button(:button, Feather[:link], class: 'btn btn-outline-secondary btn-sm btn-icon', data: {wrap: '[|]($url "$title")', keystroke: 'ctrl-a'})
    html << @builder.button(:button, Feather[:image], class: 'btn btn-outline-secondary btn-sm btn-icon', data: {wrap: '![|]($url)', keystroke: 'ctrl-shift-i'})

    html << '</div>'


    html << '</div>'

    # merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

    html << @builder.text_area(attribute_name, input_html_options)

    html
  end
end
