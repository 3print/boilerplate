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

    bp_params
  end
end
