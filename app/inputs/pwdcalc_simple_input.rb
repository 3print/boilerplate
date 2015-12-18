# Overrides pwdcalc input to add input argument and prevent warning
# when rendering the input
class PwdcalcSimpleInput < SimpleForm::Inputs::Base
  include Pwdcalc::PasswordStrength

  def input(wrapper_options = nil)
    input_html_options[:placeholder] = placeholder_text
    @builder.password_field(attribute_name, input_html_options) <<
    password_strength_score <<
    password_strength_meter
  end
end
