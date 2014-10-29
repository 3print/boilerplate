# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|
  config.wrappers :bootstrap, tag: 'div', class: 'form-group has-feedback', error_class: 'has-error', success_class: 'has-success' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label
    b.wrapper tag: 'div', class: 'controls' do |ba|
      ba.use :input
      ba.use :state_icon, wrap_with: { tag: 'span', class: 'form-control-feedback' }
      ba.use :error, wrap_with: { tag: 'span', class: 'alert alert-danger' }
      ba.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
    end
  end

  config.wrappers :prepend, tag: 'div', class: "form-group has-feedback", error_class: 'has-error', success_class: 'has-success' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label
    b.wrapper tag: 'div', class: 'controls' do |input|
      input.wrapper tag: 'div', class: 'input-prepend' do |prepend|
        prepend.use :input
      end
      input.use :state_icon, wrap_with: { tag: 'span', class: 'form-control-feedback' }
      input.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
      input.use :error, wrap_with: { tag: 'span', class: 'alert alert-danger' }
    end
  end

  config.wrappers :append, tag: 'div', class: "form-group has-feedback", error_class: 'has-error', success_class: 'has-success' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label
    b.wrapper tag: 'div', class: 'controls' do |input|
      input.wrapper tag: 'div', class: 'input-append' do |append|
        append.use :input
      end
      input.use :state_icon, wrap_with: { tag: 'span', class: 'form-control-feedback' }
      input.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
      input.use :error, wrap_with: { tag: 'span', class: 'alert alert-danger' }
    end
  end

  # Wrappers for forms and inputs using the Twitter Bootstrap toolkit.
  # Check the Bootstrap docs (http://twitter.github.com/bootstrap)
  # to learn about the different styles for forms and inputs,
  # buttons and other elements.
  config.default_wrapper = :bootstrap
end

module SimpleForm
  module Wrappers
    class Root < Many
      def html_classes(input, options)
        css = options[:wrapper_class] ? Array(options[:wrapper_class]) : @defaults[:class]
        css += SimpleForm.additional_classes_for(:wrapper) do
          input.additional_classes + [input.input_class]
        end

        css << (options[:wrapper_error_class] || @defaults[:error_class]) if input.has_errors?
        css << (options[:wrapper_success_class] || @defaults[:success_class]) if input.object.present? && input.object.validated? && !input.has_errors? && css.include?(:required)
        css << (options[:wrapper_hint_class] || @defaults[:hint_class]) if input.has_hint?
        css.compact
      end
    end
  end
end
