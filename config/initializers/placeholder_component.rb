# Overrides the SimpleForm placeholder component to retrieve placeholder for
# input type if the placeholder for the model attribute is not defined
module SimpleForm
  module Components
    # Needs to be enabled in order to do automatic lookups.
    module Placeholders
      def placeholder_text
        options[:placeholder] || placeholder_for(object, attribute_name)
      end

      def placeholder_for(model, name)
        placeholder = I18n.t("simple_form.placeholders.#{model.class.name.underscore}.#{name}", default: nil)

        if placeholder =~ /translation missing/
          placeholder = I18n.t("simple_form.placeholders.#{input_type}")
        end

        placeholder
      end
    end
  end
end
