module PillsHelper
  def pill(caption, *args, &block)
    if block_given?
      args.unshift caption
      caption = capture_haml(&block)
    else
      caption = caption.t(scope: [:actions, default_i18n_scope]) if caption.is_a? Symbol
    end

    @_pills ||= []
    @_pills << [caption, *args]
  end

  def pills
    return nil unless @_pills.present?

    out = content_tag :div, class: 'pull-right btn-group' do
      @_pills.each do |path|
        caption = path[0]

        # li_class = path[2].delete(:class) if path[2]

        if path[2] && path[2][:class]
          path[2][:class] = "btn #{path[2][:class]}"
        else
          path[2] = { class: 'btn btn-default' }
        end

        if path[1]
          caption = link_to(*path)
        elsif path[2][:is_action]
          path[2].delete(:is_action)
          caption = button_tag(*path.compact)
        end

        concat caption.html_safe# content_tag(:li, caption, class: "btn #{li_class}")
      end
    end
    @_pills = []
    out
  end
end
