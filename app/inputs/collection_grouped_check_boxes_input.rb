class CollectionGroupedCheckBoxesInput < SimpleForm::Inputs::Base
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::FormTagHelper
  include ActionView::Helpers::FormOptionsHelper
  include IconHelper


  def input(wrapper_options = nil)
    label_method, value_method, group_method, group_label_method = detect_collection_methods

    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

    grouped_collection = collection.present? ? collection.group_by(&group_method) : []
    columns = options.delete(:columns) || 1

    grouped_collection = grouped_collection.to_a.in_groups(columns)

    buffer = ''

    buffer << content_tag(:div, class: 'btn-group my-3') do
      concat(content_tag(:a, 'actions.select_all'.t, class: 'btn btn-outline-secondary', data: {checkbox_select_all: true}))
      concat(content_tag(:a, 'actions.select_none'.t, class: 'btn btn-outline-secondary', data: {checkbox_select_none: true}))
    end

    buffer << '<div class="form-check-group-row">'

    grouped_collection.each do |s|
      buffer << '<div class="form-check-group-column">'
      s.each do |a, b|
        buffer << content_tag(:fieldset) do
          concat(content_tag(:legend) do
            concat(content_tag(:label, class: options[:item_wrapper_class]) do
              concat(check_box_tag(nil, nil, false, class: 'form-check-input', data: {checkbox_binder: true}))
              concat(a.send(group_label_method))
            end)
          end)
          concat(content_tag(:div, class: 'form-check-group') do
            concat(@builder.collection_check_boxes(attribute_name, b, value_method, label_method, input_options, merged_input_options) do |b|
              b.check_box + b.text.to_s
            end)
          end)
        end
      end
      buffer << '</div>'
    end

    buffer << '</div>'

    buffer.html_safe
  end

  def detect_collection_methods
    @label_method ||= options.delete(:label_method) || :name
    @value_method ||= options.delete(:value_method) || :id
    @group_method ||= options.delete(:group_method)
    @group_label_method ||= options.delete(:group_label_method) || :name

    [@label_method, @value_method, @group_method, @group_label_method]
  end

  def collection
    @collection ||= options.delete(:collection)
  end

  def output_buffer=(v)
    @output_buffer = v
  end

  def output_buffer
    @output_buffer
  end
end
