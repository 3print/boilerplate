class CollectionSelectInput < ::SimpleForm::Inputs::CollectionSelectInput

  def input_html_options
    super.reverse_merge(placeholder: placeholder_text)
  end
end
