class PasswordsController < Devise::PasswordsController
  include DeviseExtensions

  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      redirect_to after_sending_reset_password_instructions_path_for(resource_name)
    else
      respond_to do |format|
        format.html { render 'devise/passwords/new', resource: resource }
        format.json { render json: resource, status: 'ok'}
      end
    end
  end
end
