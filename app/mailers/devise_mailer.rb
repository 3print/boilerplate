class DeviseMailer < Devise::Mailer
  default from: "no-reply@boilerplate.fr"

  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  add_template_helper(MailHelper)
  add_template_helper(SassHelper)
  add_template_helper(DateHelper)

  # default template_path: 'devise/mailer'
  # to make sure that your mailer uses the devise views
  layout 'mail'
end
