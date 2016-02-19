class Admin::BpTestsController < Admin::ApplicationController
  include OrderableExtensions

  load_resource
  sort_resource by: 'sequence ASC'

  toggle_actions :approve, off: :revocate
  toggle_actions :validate

  def resource_params
    params.require(:bp_test).permit!
  end
end
