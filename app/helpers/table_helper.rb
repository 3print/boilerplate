module TableHelper
  def widget_box(title, ico=nil, options={}, &block)
    options, ico = [ico, nil] if ico.is_a?(Hash)

    extra_title = options.delete(:extra_title)
    before_title = options.delete(:before_title)
    content_class = options.delete(:content_class)
    actions = options.delete(:actions)

    title_options = options.delete(:title) || {}
    content_options = options.delete(:content) || {}

    if options[:class]
      options[:class] = 'panel ' + options[:class]
    else
      options[:class] = 'panel panel-default'
    end

    if title_options[:class]
      title_options[:class] = 'panel-heading ' + title_options[:class]
    else
      title_options[:class] = 'panel-heading'
    end

    if content_options[:class]
      content_options[:class] = content_options[:class]
    else
      content_options[:class] = ''
    end
    content_options[:class] += ' ' + content_class if content_class

    content_tag(:div, options) do
      concat(content_tag(:div, title_options) do
        if ico
          concat(content_tag(:span, class: 'icon') do
            concat(icon(ico))
          end)
        end

        concat(before_title) if before_title
        concat(content_tag(:h5, title, class: 'panel-title'))
        if actions
          concat(content_tag(:div, class: 'buttons') do
            actions.each_pair do |path, content|
              concat(link_to content, path, class: 'btn')
            end
          end)
        end
        concat(extra_title) if extra_title
      end)

      concat(capture_haml(&block)) if block_given?
    end
  end

end
