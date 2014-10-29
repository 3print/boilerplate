module ModelsHelper
  def collection_counter(collection)
    count = collection.size
    content_tag(:div, class: 'label label-info tip-left pull-right', title: 'tips.models_count'.t(count: count, singular: "models.#{collection.klass.name.underscore}".t.downcase, plural: "models.#{collection.klass.name.pluralize.underscore}".t.downcase)) do
        concat(count)
    end
  end

  # Collection
  def models_list(collection, options={}, &block)
    columns = options[:columns] || [:id, resource_label_proc]

    col_class = collection.respond_to?(:klass) ? collection.klass : collection.first.class

    resource_name = col_class.name.underscore.pluralize
    page_param = :"#{resource_name}_page"

    collection = collection.page(params[page_param])
    pagination = paginate(collection, param_name: page_param)

    if collection.empty?
      raw "<div class='row panel-body'><em class='col-md-12'>#{:no_data_no_creation.t}</em></div>"
    else
      content_tag :table, class: "table table-bordered table-stripped table-hover #{resource_name}" do
        concat(content_tag(:thead) do
          concat(content_tag(:tr) do
            columns.each do |column|
              concat(content_tag(:th, "tables.columns.#{column.to_s}".t))
            end
          end)
        end)

        concat(content_tag(:tbody) do
          collection.each do |item|
            if block_given?
              block.call(item).html_safe
            else
              concat(content_tag(:tr) do
                columns.each do |column|
                  concat(content_tag(:td, column.to_proc.call(item), class: column))
                end
              end)
            end
          end

          if pagination.present?
            concat(content_tag(:tr) do
              concat(content_tag(:td, pagination, colspan: columns.size, class: 'fg-toolbar ui-toolbar ui-widget-header ui-corner-bl ui-corner-br ui-helper-clearfix', style: 'display: table-cell;'))
            end)
          end
        end)
      end
    end
  end

  def collection_class= klass
    @collection_class = klass
  end

  def collection_class
    @collection_class || self.resource_class
  end

  def collection collection, options={}
    local = options[:local] || collection.klass.name.tableize.to_sym
    page_param = options[:page_param] || (action_name == 'index' ? :page : "#{local}_page")
    resource_class = options[:resource_class] || self.resource_class
    collection = collection.page(params[page_param])
    # collection = collection.order("#{resource_class.table_name}.created_at DESC").page(params[page_param])
    self.collection_class = collection.klass

    if collection.empty?
      content_tag :div, class: 'row panel-body' do
        concat(content_tag(:div, class: 'col-md-12') do
          if can? :create, collection_class
            message = I18n.t("models.#{collection_class.name.tableize}.no_data", default: '')
            message = :no_data.t if message.blank?
          else
            message = I18n.t("models.#{collection_class.name.tableize}.no_data_no_creation", default: '')
            message = :no_data_no_creation.t  if message.blank?
          end
          concat raw "<em>#{message}</em>"
        end)
      end

    else
      if options[:partial].present?
        html = render partial: options[:partial], locals: { collection: collection, resource_class: resource_class }
      else
        html = contextual_partial 'list', locals:{ collection: collection }, resource_class: collection_class
      end
      pagination = paginate(collection, param_name: page_param)
      resource_name = resource_class.model_name.human.pluralize(I18n.locale).underscore

      res = ''
      # res += pagination if pagination.present?
      res += html
      res += content_tag :div, class: 'panel-footer' do
        concat(pagination)
      end if pagination.present?

      res.html_safe
    end
  end

end
