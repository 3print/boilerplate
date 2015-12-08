class Admin::BpTestsController < Admin::ApplicationController
  def resource_params
    params.require(:bp_test).permit!
  end

  toggle_actions :approve, off: :revocate
  toggle_actions :validate
end
