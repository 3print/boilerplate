class StaticController < ApplicationController
  layout :which_layout

  def which_layout
    if params[:action] == 's3_results'
      'results'
    else
      'application'
    end
  end
end
