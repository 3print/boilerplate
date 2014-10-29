module NestedFormHelper
  # NestedForm helpers

  def nested_form_add(form, options={}, &block)
    capture_haml do
      haml_tag 'tr', class: 'fields actions' do
        haml_tag 'td', colspan: options[:cols] do
          haml_tag 'div', class: 'btn-group' do
            haml_concat capture_haml(&block) if block_given?

            haml_concat(form.link_to_add(options[:for], class: 'btn btn-success') do
                haml_tag 'span', class: icon_class('plus')
                haml_concat 'actions.add'.t
            end)
          end
        end
      end
    end
  end

  def nested_form_remove(form, options={}, &block)
    capture_haml do
      haml_tag 'td', colspan: options[:cols] do
        haml_concat(form.link_to_remove(class: 'btn btn-danger') do
          haml_tag 'span', class: icon_class('times')
          haml_concat 'actions.remove'.t
        end)

        haml_tag 'div', class: 'btn-group' do
          haml_concat capture_haml(&block).html_safe if block_given?
        end

      end
    end
  end

end
