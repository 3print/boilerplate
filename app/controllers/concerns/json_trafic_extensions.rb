require 'active_support/concern'

module JsonTraficExtensions
  extend ActiveSupport::Concern

  def index
    render json: resource, each_serializer: resource_serializer
  end

  included do
    rescue_from ActiveRecord::RecordInvalid, with: :handle_invalid_record
    rescue_from ActiveRecord::RecordNotFound, with: :render_404
  end

  [:new, :show, :edit].each do |name|
    define_method name do
      render json: resource, serializer: resource_serializer
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
    render json: resource, serializer: resource_serializer
  end

  def destroy_response
    render json: { status: :ok }
  end

  def build_resource
    resource.assign_attributes resource_params
  end

  def save_resource
    build_resource

    args = [:save]

    resource.save!
  end

  def destroy_resource
    args = [:destroy]

    if resource.respond_to? :destroy!
      resource.destroy!
    else
      resource.destroy
    end
  end

  def handle_invalid_record
    render json: resource.errors, each_serializer: ErrorSerializer, status: 422
  end

  def render_404
    render json: { status: :not_found }, status: 404
  end
end
