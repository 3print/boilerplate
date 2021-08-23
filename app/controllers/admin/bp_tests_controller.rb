class Admin::BpTestsController < Admin::ApplicationController
  include OrderableExtensions
  include JsonExtensions

  load_resource
  sort_resource by: 'sequence ASC'

  toggle_actions :approve, off: :revocate
  toggle_actions :validate

  def resource_params
    bp_params = params.require(:bp_test).permit!

    if bp_params[:json].present?
      bp_params[:json] = arrayify(bp_params[:json])
    end

    if bp_params[:visual_regions].present?
      bp_params[:visual_regions].each_pair do |k,v|
        bp_params[:visual_regions][k] = JSON.parse(v)
      end
    end

    bp_params
  end
end
