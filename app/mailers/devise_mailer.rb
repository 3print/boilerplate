class DeviseMailer < Devise::Mailer
  include Devise::Controllers::UrlHelpers
  add_template_helper(MailHelper)
  add_template_helper(AssetsHelper)

  default from: "no-reply@boilerplate.fr"
  default template_path: 'devise/mailer'


  # default template_path: 'devise/mailer'
  # to make sure that your mailer uses the devise views
  layout 'mailer'
end
