class ConsentsController < ApplicationController
  def register
    cookies[:cookies_consent] = {
      expires: 1.year,
      value: consent_params,
    }
    render json: consent_params
  end

  def consent_params
    params.require(:consent).permit!
  end
end
