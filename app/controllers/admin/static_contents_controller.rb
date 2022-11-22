class Admin::StaticContentsController < Admin::ApplicationController
  def resource_params
    params.require(:static_content).permit(:name, :content, seo_meta_attributes: [:title, :description])
  end

end
