class BpTestsController < ApplicationController
  def resource_params
    params.require(:bp_test).permit!
  end
end
