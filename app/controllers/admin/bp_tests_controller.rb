class Admin::BpTestsController < Admin::ApplicationController
  toggle_actions :approve, off: :revocate
  toggle_actions :validate

  def resource_params
    params.require(:bp_test).permit!
  end
end
