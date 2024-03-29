module PartialsHelper
  def contextual_partial name, options={}, &blk
    resource_class = options[:resource_class] || self.collection_class
    prefixes = options[:prefixes] || controller.class.name.split('::')[0..-2].map(&:underscore)
    partial = options[:partial] || "#{resource_class.table_name}/#{name}"
    filename_parts = partial.split "/"
    filename = [filename_parts[0..-2], "_#{filename_parts.last}.html.haml"].join("/")

    key = block_given? ? :layout : :partial

    if lookup_context.exists? "_#{filename_parts.last}", (prefixes + filename_parts[0..-2]).uniq.join('/')
      html = render({key => (prefixes + filename_parts).uniq.join('/')}.update(options), &blk)
    elsif prefixes.include?("admin") && lookup_context.exists?("_#{filename_parts.last}", "admin/application")
      html = render({key => "admin/application/#{name}"}.update(options), &blk)
    else
      html = render({key => "application/#{name}"}.update(options), &blk)
    end
    html
  end

  def render_partial_for_user(partial, options={})
    original_partial = partial

    if current_user.present? && current_user.role != 'user'
      controller_prefixes = controller.send(:_prefixes)
      path_elements = partial.split('/')
      partial = "_#{path_elements.pop}"
      prefix = path_elements.join('/')
      prefixes = prefix.empty? ? controller_prefixes : [prefix]

      role = current_user.role
      partial_name = "#{partial}_for_#{role}"
      if lookup_context.exists? partial_name, prefixes
        partial_name = "#{original_partial}_for_#{role}"
        render({ partial: partial_name }.merge(options))
      else
        render({ partial: original_partial }.merge(options))
      end
    else
      render({ partial: original_partial }.merge(options))
    end
  end

  def partial_exist?(partial)
    controller_prefixes = controller.send(:_prefixes)
    path_elements = partial.split('/')
    partial = "_#{path_elements.pop}"
    prefix = path_elements.join('/')
    prefixes = prefix.empty? ? controller_prefixes : [prefix]

    lookup_context.exists? partial, prefixes
  end
end
