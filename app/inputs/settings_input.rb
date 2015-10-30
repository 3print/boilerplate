class SettingsInput < SimpleForm::Inputs::TextInput
  def input
    class_name = @builder.object.class.name.singularize.underscore
    res = "<table class='settings_editor table table-bordered table-stripped' data-row-blueprint='#{light_escape(get_field_row '', '')}' data-model='#{class_name}' data-attribute-name='#{attribute_name}'>"

    res += '<thead><tr>'
    %w(field type).each do |k|
      res += "<th>#{"tables.columns.#{k}".t}</th>"
    end
    res += "<th></th>"
    res += '</tr></thead>'

    hash = @builder.object.send(attribute_name)

    hash.each do |k,v|
      res += get_field_row k, v
    end if hash.present?

    res += "<tr><td colspan='3'><a href='#' class='add btn btn-success'><i class='fa fa-plus'></i> #{'actions.add'.t}</a></td></tr>"

    res += '</table>'
    res
  end

  def light_escape(string)
    string.gsub('<', '&lt;').gsub('>', '&gt;').gsub('"', "\"")
  end

  def get_field_row(field, value)
    class_name = @builder.object.class.name.singularize.underscore
    value_is_collection = !!(value =~ /,/)

    if value_is_collection
      initial_type = 'collection'
    else
      initial_type = value
    end

    types = [
      :integer,
      :float,
      :string,
      :boolean,
      :markdown,
      :collection,
      :job,
      :date,
      :date_range
    ]

    row = '<tr>'

    row += '<td>'
    row += "<input type=\"hidden\" name=\"#{class_name}[#{attribute_name}][#{field}]\" value=\"#{value}\"></input>"
    row += "<input type=\"text\" value=\"#{field}\" class=\"form-control\"></input>"
    row += '</td>'
    row += "<td><select data-original-value=\"#{value}\" data-original-type=\"#{initial_type}\" style=\"width: 100%\">"

    ([''] + types).each do |type|
      selected = type.to_s == initial_type.to_s

      row += "<option value=\"#{type}\" #{selected ? 'selected' : ''}>#{type == '' ? '' : "enums.settings.types.#{type}".t.gsub("'", '&#39;')}</option>"
    end
    row += '</select>'

    row += '</td>'

    row += '<td>'
    row += '<a href="#" class="remove btn btn-danger"><i class="fa fa-remove"></i></a>'

    row += '</td>'
    row += '</tr>'
    row
  end

end
