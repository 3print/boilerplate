require 'active_support/concern'

module TraficExtensions
  extend ActiveSupport::Concern


  def index
    respond_to do |format|
      format.html
      format.json
    end
  end

  included do
    rescue_from ActiveRecord::RecordInvalid, with: :handle_invalid_record
    rescue_from ActiveRecord::RecordNotFound, with: :render_404
  end

  [:new, :show, :edit].each do |name|
    define_method name do
      respond_to do |format|
        format.html
        format.json { render json: resource }
      end
    end
  end

  def create
    save_resource
    success_response
  end

  def update
    save_resource
    success_response
  end

  def destroy
    destroy_resource
    destroy_response
  end

  def success_response
    respond_to do |format|
      format.html { redirect_to resource_location }
      format.json { render json: {id: resource.id} }
    end
  end

  def destroy_response
    respond_to do |format|
      format.html { redirect_to resource_path(:index) }
      format.json { render json: {status: :ok} }
    end
  end

  def build_resource
    resource.assign_attributes resource_params
  end

  def save_resource
    build_resource

    args = [:save]
    args << action_name unless ::Rails.version.to_f >= 4.0

    resource.save!
  end

  def destroy_resource
    args = [:destroy]
    args << action_name unless ::Rails.version.to_f >= 4.0

    if resource.respond_to? :destroy!
      resource.destroy!
    else
      resource.destroy
    end
  end

  def handle_invalid_record
    case params[:action]
    when 'create' then render :new, status: 422
    when 'update' then render :edit, status: 422
    end
  end

  def render_404
    respond_to do |format|
      format.html { render 'shared/404', status: :not_found }
      format.json { render json: { status: :not_found } }
    end
  end
end
