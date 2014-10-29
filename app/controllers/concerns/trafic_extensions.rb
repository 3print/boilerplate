require 'active_support/concern'

module TraficExtensions
  extend ActiveSupport::Concern
  

  def index
    respond_with resource
  end

  included do
    rescue_from ActiveRecord::RecordInvalid, with: :handle_invalid_record
  end

  [:new, :show, :edit].each do |name|
    define_method name do
      respond_with resource
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
    respond_with resource, location: resource_location
  end

  def destroy_response
    respond_with resource, location: resource_path(:index)
  end

  def save_resource
    resource.assign_attributes resource_params

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

end
