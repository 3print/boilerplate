class Admin::MasqueradesController < Devise::MasqueradesController
  def show
    authorize User, :masquerade?

    super
  end

  def after_masquerade_path_for(resource)
    if resource.user?
      root_path
    else
      admin_root_path
    end
  end

  def after_back_masquerade_path_for(resource)
    if resource.user?
      root_path
    else
      admin_root_path
    end
  end
end
