class FileInput < SimpleForm::Inputs::FileInput
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::FormTagHelper
  include ActionView::Helpers::FormOptionsHelper

  def input(wrapper_options = nil)
    buffer = "<div class='controls'><div class='file-content form-control #{object.try("#{attribute_name}?") ? 'with-value' : '' }'>"

    buffer << preview

    opts = input_html_options.merge(id: hidden_dom_id, class: 'url')

    # if CarrierWave::Uploader::Base.storage == CarrierWave::Storage::AWS
    #   if object.respond_to?(:"#{attribute_name}_tmp")
    #     buffer << @builder.hidden_field(:"#{attribute_name}_tmp", opts)
    #   else
    #     buffer << @builder.hidden_field(:"remote_#{attribute_name}_url", opts)
    #   end
    #   buffer << @builder.hidden_field(:"remove_#{attribute_name}", input_html_options.merge(id: "remove_#{hidden_dom_id}"))
    # else
    #  buffer << super
    # end

    buffer << super

    buffer << '</div>'

    has_gravity = object.respond_to?(:"#{attribute_name}_gravity")
    has_alt_text = object.respond_to?(:"#{attribute_name}_alt_text")

    if has_gravity
      input_html_classes << "with-crop-settings"
      buffer << '<div class="crop-settings">'
      buffer << @builder.label('simple_form.labels.crop_settings'.t)
      buffer << select_tag(
        "#{object_name}[#{attribute_name}_gravity]",
        options_for_select(
          [['', '']] + %w(north south east west north_west north_east south_west south_east center).map { |s| ["enums.file.gravity.#{s}".t, "#{attribute_name}_#{s}"] },
          object.send(:"#{attribute_name}_gravity")
        ),
        placeholder: 'simple_form.placeholders.crop_settings'.t,
        class: 'form-control',
      )
      buffer << '</div>'
    end

    if has_alt_text
      buffer << text_field_tag(
        "#{object_name}[#{attribute_name}_alt_text]",
        object.send(:"#{attribute_name}_alt_text"),
        placeholder: 'simple_form.placeholders.alt_text'.t,
        class: 'string form-control file_alt_text'
      )
    end

    # rubocop:disable Lint/NestedMethodDefinition
    def input_html_options
      super.merge(required: required?)
    end

    def required?
      required_by_validators? && object.send(attribute_name).blank?
    end
    # rubocop:enable Lint/NestedMethodDefinition
    buffer << '</div>'

    buffer.html_safe
  end

  def hidden_dom_id
    dup = self.dup
    "#{dup.__id__}_tmp"
  end

  def preview
    if object.try("#{attribute_name}?")
      template.content_tag :div, class: 'current-value' do
        s = ''.html_safe

        image = object.send(attribute_name)
        ext = image.present? ? clear_url_query(File.extname(image.url)) : nil
        if image_extensions.include?(ext)
          s << build_preview(image).html_safe
        else
          s << build_file_path(image).html_safe
        end

        s
      end
    else
      ''
    end
  end

  def default_field_label
    "<div class='placeholder'>#{input_html_options[:placeholder] || 'actions.browse'.t}</div>".html_safe
  end

  def build_file_path(uploader)
    file_name = uploader.file.path.to_s.split('/').last
    file_ext = file_name.split('.').last

    template.content_tag(:div, '', class: "fa fa-file-#{file_ext}-o") + ' ' + file_name
  end

  def build_preview(image)
    version = get_version(image)
    if version.present?
      '' << template.image_tag(version.url) << field_label(image)
    else
      ""
    end
  end

  def get_version(image)
    if options[:version] && image.respond_to?(options[:version])
      image.send(options[:version])
    elsif image.respond_to?(:file_input)
      image.thumb
    else
      image
    end
  end

  def image_extensions
    %w(.png .gif .jpg .jpeg .PNG .GIF .JPG .JPEG)
  end

  def clear_url_query(ext)
    ext.split('?').first
  end

  def field_label(res)
    s = "<div class='name'>#{clear_url_query res.to_s.split('/').last}</div>"
    s += "<div class='meta'>"
    s += "<div class='mime'>#{res.content_type}</div>"
    s += "<div class='size'>#{(res.file.size rescue 0) / 1024}ko</div>"
    s += "<div class='dimensions'>#{res.width rescue '?'}x#{res.height rescue '?'}px</div>"
    s += "</div>"

    s.html_safe
  end
end
