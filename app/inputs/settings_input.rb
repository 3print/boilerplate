class SettingsInput < SimpleForm::Inputs::TextInput
  TYPES = [
    :integer,
    :float,
    :string,
    :boolean,
    :markdown,
    :collection,
    :date,
    :datetime,
    :time,
    :image,
    :resource
  ]

  def self.types
    TYPES
  end

  def input(wrapper_options = nil)
    class_name = @builder.object.class.name.singularize.underscore
    res = "<table class='settings_editor table table-bordered table-stripped no-action-labels' data-row-blueprint='#{light_escape(get_field_row '', '')}' data-model='#{class_name}' data-attribute-name='#{attribute_name}'>"

    res += '<thead class="bg-light"><tr>'
    %w(field type).each do |k|
      res += "<th>#{"tables.columns.#{k}".t}</th>"
    end
    res += "<th></th>"
    res += '</tr></thead>'

    hash = @builder.object.send(attribute_name)

    hash.each do |k,v|
      res += get_field_row k, v
    end if hash.present?

    res += "<tr><td colspan='3' class='bg-light'><a href='#' class='add btn btn-outline-success'>#{Feather['plus-square']}</i> #{'actions.add'.t}</a></td></tr>"

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

    id = [class_name, attribute_name, field].join('_').underscore

    row = '<tr>'

    row += '<td>'
    row += "<input type=\"hidden\" name=\"#{class_name}[#{attribute_name}][#{field}]\" id=\"#{id}\""
    row += " value='#{value.is_a?(Hash) ? value.to_json : value}'" if field.present?
    row += "></input>"
    row += "<div class=\"form-group has-feedback\"><div class=\"controls\"><input type=\"text\" value=\"#{field}\" class=\"form-control\" required></input></div></div>"
    row += '</td>'
    row += "<td><div class=\"form-group has-feedback\"><div class=\"controls\"><select class=\"form-control\" style=\"width: 100%\" placeholder=\"#{placeholder}\" required>"

    ([''] + types).each do |type|
      row += "<option value=\"#{type}\">#{type == '' ? '' : "enums.settings.types.#{type}".t.gsub("'", '&#39;')}</option>"
    end

    row += '</select></div></div>'
    row += '<div class="additional"></div>'

    row += '</td>'

    row += '<td>'
    row += "<a href=\"#\" class=\"remove btn btn-outline-danger\">#{Feather[:x].gsub("'", '"')}</a>"

    row += '</td>'
    row += '</tr>'
    row
  end

end
