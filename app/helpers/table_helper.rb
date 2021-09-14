module TableHelper
  def widget_box(title, ico=nil, options={}, &block)
    options, ico = [ico, nil] if ico.is_a?(Hash)

    extra_title = options.delete(:extra_title)
    before_title = options.delete(:before_title)
    actions = options.delete(:actions)

    title_options = options.delete(:title) || {}
    content_options = options.delete(:content) || {}

    if options[:class].present?
      options[:class] += ' card'
    else
      options[:class] = 'card'
    end

    if title_options[:class]
      title_options[:class] = 'card-header ' + title_options[:class]
    else
      title_options[:class] = 'card-header'
    end

    content_tag(:div, options) do
      concat(content_tag(:div, title_options) do
        concat(before_title) if before_title
        concat(content_tag(:h5, class: 'card-title mb-0') do
          if ico
            concat(icon(ico))
            concat(' ')
          end

          concat(title)
          if actions
            concat(content_tag(:div, class: 'buttons') do
              actions.each_pair do |path, content|
                concat(link_to content, path, class: 'btn')
              end
            end)
          end
        end)
        concat(extra_title) if extra_title
      end)

      concat(capture_haml(&block)) if block_given?
    end
  end

end
