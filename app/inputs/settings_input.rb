class SettingsInput < SimpleForm::Inputs::TextInput
  TYPES = [
    :integer,
    :float,
    :string,
    :boolean,
    :markdown,
    :collection,
    :date,
    :date_range
  ]

  def self.types
    TYPES
  end

  def input(wrapper_options = nil)
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

    types = self.class.types
    placeholder = 'simple_form.placeholders.type'.t

    row = '<tr>'

    row += '<td>'
    row += "<input type=\"hidden\" name=\"#{class_name}[#{attribute_name}][#{field}]\""
    row += " value='#{value}'" if field.present?
    row += "></input>"
    row += "<input type=\"text\" value=\"#{field}\" class=\"form-control\"></input>"
    row += '</td>'
    row += "<td><select style=\"width: 100%\" placeholder=\"#{placeholder}\">"

    ([''] + types).each do |type|
      row += "<option value=\"#{type}\">#{type == '' ? '' : "enums.settings.types.#{type}".t.gsub("'", '&#39;')}</option>"
    end

    row += '</select>'
    row += '<div class="additional"></div>'

    row += '</td>'

    row += '<td>'
    row += '<a href="#" class="remove btn btn-danger"><i class="fa fa-remove"></i></a>'

    row += '</td>'
    row += '</tr>'
    row
  end

end
