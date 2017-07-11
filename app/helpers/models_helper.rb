module ModelsHelper
  SKIPPED_COLUMNS = [
    :created_at, :updated_at, :created_on, :updated_on,
    :lock_version, :version, :sequence, :permalink,

    # Devise
    :encrypted_password, :reset_password_token, :reset_password_sent_at,
    :last_sign_in_at, :last_sign_in_ip,
    :current_sign_in_at, :current_sign_in_ip,
    :remember_created_at, :approved_at,

    # CarrierWave Meta
    :avatar_meta, :avatar_gravity,
    :image_meta, :image_gravity,

    # Misc
    :avatar_tmp, :image_tmp,

    # Syncables
    :uuid
  ].freeze

  def default_columns_for_object(model)
    cols = association_columns(model, :belongs_to)
    cols += content_columns(model)
    cols -= ModelsHelper::SKIPPED_COLUMNS
    cols -= model.class::SKIPPED_COLUMNS.map(&:intern) if model.class::SKIPPED_COLUMNS.present? rescue false
    cols += model.class::EXTRA_COLUMNS.map(&:intern) if model.class::EXTRA_COLUMNS.present? rescue false

    cols.compact
  end

  def association_columns(object, *by_associations)
    if object.present? && object.class.respond_to?(:reflections)
      object.class.reflections.collect do |name, association_reflection|
        if by_associations.present?
          if by_associations.include?(association_reflection.macro) && association_reflection.options[:polymorphic] != true
            name
          end
        else
          name
        end
      end.compact.map(&:intern)
    else
      []
    end
  end

  def content_columns(object)
    # TODO: NameError is raised by Inflector.constantize. Consider checking if it exists instead.
    klass = object.class
    return [] unless klass.respond_to?(:content_columns)
    klass.content_columns.collect { |c| c.name.to_sym }.compact
  end

  def show_field(col, options={})
    res = options[:resource] || resource
    resource_name = res.class.table_name
    out = res.send(col)

    if options[:as].present?
      type = options[:as]
      type_partial = "show_#{type}_field"
      if partial_exist?(type_partial)
        return render partial: type_partial, locals: { value: out, type: type, column: col, resource: res, resource_name: resource_name, options: options }
      end
    end

    column = res.class.columns_hash[col.to_s]
    type = res.class.get_column_display_type(col)
    type ||= column.present? ? column.type : :association
    type = :image if out.is_a?(CarrierWave::Uploader::Base)
    type = :active_record if out.is_a?(ActiveRecord::Base)

    type_partial = "show_#{type}_field"

    locals = { value: out, type: type, column: col, resource: res, resource_name: resource_name, options: options }

    if partial_exist?(type_partial)
      render partial: type_partial, locals: locals
    else
      render partial: 'show_default_field', locals: locals
    end
  end

  # Collection

  def collection_class= klass
    @collection_class = klass
  end

  def collection_class
    @collection_class || self.resource_class
  end

  def collection_counter(collection)
    return content_tag(:div, 0, class: 'label label-info tip-left pull-right') if collection.size == 0

    model_class = collection.is_a?(Array) ? collection.first.try(:class) : collection.klass
    count = collection.size
    content_tag(:div, class: 'label label-info tip-left pull-right', title: 'tips.models_count'.t(count: count, singular: "models.#{model_class.namespaced_name}".t.downcase, plural: "models.#{model_class.table_name}".t.downcase)) do
        concat(count)
    end
  end

  def models_list(collection, options={}, &block)
    columns = options[:columns] || [:id, resource_label_proc]

    col_class = collection.respond_to?(:klass) ? collection.klass : collection.first.class

    resource_name = col_class.table_name
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

  def collection collection, options={}
    page_param = options[:page_param] || :page
    collection = collection.page(params[page_param])
    self.collection_class = options[:collection_class] || collection.klass

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
        html = render partial: options[:partial], locals: { collection: collection, collection_class: collection_class }
      else
        html = contextual_partial 'list', locals:{ collection: collection, collection_class: collection_class }, resource_class: collection_class
      end
      pagination = paginate(collection, param_name: page_param)

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
