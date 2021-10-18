class DeviseMailerPreview < ActionMailer::Preview
  def reset_password_instructions
    u = User.last
    DeviseMailer.reset_password_instructions(u, '<token>')
  end
end
