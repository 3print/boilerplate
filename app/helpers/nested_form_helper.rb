module NestedFormHelper
  # NestedForm helpers

  def nested_form_add(form, options={}, &block)
    capture_haml do
      content_tag('tr', class: 'fields actions') do
        content_tag('td', colspan: options[:cols]) do
          content_tag('div', class: 'btn-group') do
            concat(capture_haml(&block)) if block_given?

            concat(form.link_to_add(options[:for], class: 'btn btn-success') do
              content_tag 'span', class: icon_class('plus')
              concat 'actions.add'.t
            end)
          end
        end
      end
    end
  end

  def nested_form_remove(form, options={}, &block)
    capture_haml do
      content_tag 'td', colspan: options[:cols] do
        concat(form.link_to_remove(class: 'btn btn-danger') do
          content_tag 'span', class: icon_class('times')
          concat 'actions.remove'.t
        end)

        concat(content_tag('div', class: 'btn-group') do
          concat capture_haml(&block).html_safe if block_given?
        end)
      end
    end
  end

end
