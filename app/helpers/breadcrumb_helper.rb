module BreadcrumbHelper
  def controller_breadcrumb
    a = []
    namespace = controller.respond_to?(:controller_breadcrumb) ? controller.controller_breadcrumb : controller.controller_namespace
    is_admin = namespace.any? {|c| c == :admin }
    a << :admin if is_admin
    if namespace.any? {|c| c != :admin }
      namespace.reject {|c| c == :admin }.each do |scope|
        if scope.is_a?(ActiveRecord::Base)
          klass = scope.class.name.pluralize.underscore.to_sym
          breadcrumb "models.#{klass}".t, a + [klass]
        end
        a = a + [scope]
        breadcrumb resource_label_for(scope), a
      end
    end
  end

  def breadcrumb caption, *args
    scope = @virtual_path.split(%r{/_?})[0..-2]
    caption = caption.t(scope: scope) if caption.is_a? Symbol

    @_breadcrumb_paths ||= []
    @_breadcrumb_paths << [caption, *args].compact
  end

  def breadcrumbs(divider='', &block)
    # return nil unless @_breadcrumb_paths.present?

    root = controller.is_admin? ? [:admin, :root] : [:root]
    # root = [:root]

    content_tag :ul, id: 'breadcrumb', class: 'breadcrumb', itemscope: true, itemtype: 'http://schema.org/BreadcrumbList' do
      txt = ([:nav] + root).join('.').t

      concat(content_tag(:span, capture_haml(&block), class: 'text')) if block_given?

      concat(content_tag(:li, itemprop: "itemListElement", itemscope: true,
      itemtype: "http://schema.org/ListItem") do
        content_tag(:a, href: url_for(root), itemprop: :item) do
          concat(content_tag(:span, txt, itemprop: :name))
          concat(tag(:meta, content: 1, itemprop: :position))
        end
      end)

      (@_breadcrumb_paths || []).each.with_index do |path, i|

        if path[1]
          txt, url = path
          caption = content_tag(:a, href: url_for(url), itemprop: :item) do
            concat(content_tag(:span, txt, itemprop: :name))
            concat(tag(:meta, content: i + 2, itemprop: :position))
          end #link_to(*path)
        else
          caption = content_tag(:a, class: 'active', href: '#') do
            concat(content_tag(:span, path[0], itemprop: :name))
            concat(tag(:meta, content: i + 2, itemprop: :position))
          end
        end

        li_class = path[2].delete(:class) if path[2]

        concat content_tag(:li, caption, class: li_class, itemprop: "itemListElement", itemscope: true,
        itemtype: "http://schema.org/ListItem")
      end
    end
  end
end
