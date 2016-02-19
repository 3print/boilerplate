class Admin::SeoMetaController < Admin::ApplicationController
  load_resource
  scope_resource :no_owner
  sort_resource by: 'created_at DESC'

  def resource_params
    params.require(:seo_meta).permit(:title, :description, :meta_owner_type, :meta_owner_id, :static_mode, :static_action)
  end
end
