module ModelsHelper
  def collection_counter(collection)
    count = collection.size
    content_tag(:div, class: 'label label-info tip-left pull-right', title: 'tips.models_count'.t(count: count, singular: "models.#{collection.klass.name.underscore}".t.downcase, plural: "models.#{collection.klass.name.pluralize.underscore}".t.downcase)) do
        concat(count)
    end
  end

  def phone_number(phone)
    return '' if phone.nil?
    match = /(.+)?(\d{10})/.match phone.gsub(/[^\d\+]/, '')
    return phone if match.nil?

    prefix = match[1]
    numbers = match[2].gsub(/(.{2})/, '\1 ')
    [prefix, numbers].compact.join(' ')
  end

  def show_field(col, options={})
    out = resource.send(col)

    if options[:as].present?
      type = options[:as]
      type_partial = "show_#{type}_field"
      if partial_exist?(type_partial)
        return render partial: type_partial, locals: { value: out, type: type, column: col }
      end
    end

    column = controller.resource_class.columns_hash[col.to_s]
    type = controller.resource_class.get_column_display_type(col)
    type ||= column.present? ? column.type : :association
    type = :image if out.present? and out.is_a?(CarrierWave::Uploader::Base)

    field_partial = "show_#{controller.resource_name}_#{col}"
    type_partial = "show_#{type}_field"

    if partial_exist?(field_partial)
      render partial: field_partial, locals: { value: out, type: type, column: col }
    elsif partial_exist?(type_partial)
      render partial: type_partial, locals: { value: out, type: type, column: col }
    elsif out.is_a?(ActiveRecord::Base)
      render partial: 'show_active_record_field', locals: { value: out, type: type, column: col }
    else
      render partial: 'show_default_field', locals: { value: out, type: type, column: col }
    end
  end

  # Collection
  def models_list(collection, options={}, &block)
    columns = options[:columns] || [:id, resource_label_proc]

    col_class = collection.respond_to?(:klass) ? collection.klass : collection.first.class

    resource_name = col_class.name.underscore.pluralize
    page_param = :"#{resource_name}_page"

    per = options[:per] || options[:limit] || 10

    unless options[:no_pagination]
      collection = collection.page(params[page_param]).per(per)
      pagination = paginate(collection, param_name: page_param)
    end

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
              concat(content_tag(:td, pagination, colspan: columns.size, class: 'table-footer', style: 'display: table-cell;'))
            end)
          elsif options[:footer]
            concat(content_tag(:tr) do
              concat(content_tag(:td, options[:footer].html_safe, colspan: columns.size, class: 'table-footer', style: 'display: table-cell;'))
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
        html = contextual_partial 'list', locals:{ collection: collection, resource_class: collection_class }, resource_class: collection_class
      end
      pagination = paginate(collection, param_name: page_param)
      resource_name = resource_class.model_name.human.pluralize(I18n.locale).underscore

      res = ''
      # res += pagination if pagination.present?
      res += html
      if pagination.present?
        res += content_tag :div, class: 'panel-footer' do
          concat(pagination)
        end
      end

      res.html_safe
    end
  end

end
