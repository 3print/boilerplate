class FileInput < SimpleForm::Inputs::FileInput

  def input
    use_aws = CarrierWave::Uploader::Base.storage == CarrierWave::Storage::Fog
    buffer = ''
    if use_aws
      opts = input_html_options.merge(id: hidden_dom_id, class: 'url')
      buffer << @builder.hidden_field(:"remote_#{attribute_name}_url", opts)
      buffer << preview
      buffer.html_safe
    else
      buffer << @builder.file_field(attribute_name, input_html_options)
      buffer << default_field_label
    end
    buffer.html_safe
  end

  def hidden_dom_id
    dup = self.dup
    "#{dup.__id__}_tmp"
  end

  def preview
    template.content_tag :div, class: 'preview' do
      s = '<div class="progress"><div class="progress-bar progress-bar-success"></div></div>'.html_safe

      if object.try("#{attribute_name}?")
        image = object.send(attribute_name)
        ext = image.present? ? clear_url_query(File.extname(image.url)) : nil
        if image_extensions.include?(ext)
          s << build_preview(image).html_safe
        else
          s << build_file_path(image).html_safe
        end
      else
        s << default_field_label
      end

      s
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

  def build_preview image
    version = get_version(image)
    if version.present?
      '' << template.image_tag(version) << field_label(image)
    else
      ""
    end
  end

  def get_version image
    if @options[:version] && image.respond_to?(@options[:version])
      image.send(@options[:version])
    elsif image.respond_to?(:thumb)
      image.thumb
    else
      image
    end
  end

  def image_extensions
    %w(.png .gif .jpg .jpeg)
  end

  def clear_url_query(ext)
    ext.split('?').first
  end

  def field_label res
    return '' if not res.respond_to?(:width) and not res.respond_to?(:height)
    s = "<div class='label label-default' title='#{res}'>#{clear_url_query res.to_s.split('/').last}</div>"
    s += "<div class='meta'>"
    s += "<div class='dimensions'><span class='number'>#{res.width}</span>x<span class='number'>#{res.height}</span>px</div>"
    s += "<div class='size'><span class='number'>#{res.file_size / 1024}</span>ko</div>"
    s += "</div>"

    s.html_safe
  end
end
