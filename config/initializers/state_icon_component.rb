module SimpleForm
  module Components
    module StateIcon
      def state_icon(wrapper_options = nil)
        @state_icon ||= begin
          if object.present? && object.was_validated?
            if has_errors?
              template.icon(:times)
            else
              template.icon(:check)
            end
          else
            nil
          end
        end
      end

      def has_state_icon?
        required_field? || has_validators?
      end
    end
  end
end

SimpleForm::Inputs::Base.send(:include, SimpleForm::Components::StateIcon)
