require 'active_support/concern'

module ResourceExtensions
  extend ActiveSupport::Concern

  ALL_ACTIONS = %i(index new create edit update destroy)

  included do
    def self.resource_name
      self.name.gsub('Controller', '').split('::').last.underscore
    rescue
      nil
    end

    def self.resource_class
      self.name.gsub('Controller', '').split('::').last.singularize.constantize
    rescue
      nil
    end

    def self.load_resource(options={})
      before_action options do
        resource
      end
    end

    def self.load_and_authorize_resource(options={})
      before_action options do
        unless self.class.instance_variable_get "@skip_load_and_authorize_resource"
          resource authorize: true
        end
      end
    end

    def self.skip_load_and_authorize_resource(options={})
      @skip_load_and_authorize_resource = true
    end

    def self.sort_resource(options={})
      sort = options.delete(:by)

      options[:only] = :index if options.empty?

      before_action options do
        key = :"@#{resource_name}"
        instance_variable_set(key, instance_variable_get(key).order(sort))
      end
    end

    def self.scope_resource(scope=nil, options={}, &blk)
      scope, options = [nil, options] if scope.is_a?(Hash)

      options[:only] = :index if options.empty?

      before_action options do
        key = :"@#{resource_name}"
        resource
        if block_given?
          scope = instance_variable_get(key)
          scope = instance_exec scope, &blk
          set_resource key, scope
        else
          set_resource(key, instance_variable_get(key).send(scope))
        end
      end
    end

    def self.paginate_resource(options={})
      options[:only] = :index if options.empty?
      per = options.delete(:per)

      before_action options do
        key = :"@#{resource_name}"
        resource

        paginated_resource = instance_variable_get(key).page(params[:page] || 1)
        paginated_resource = paginated_resource.per(per) if per.present?
        set_resource(key, paginated_resource)
      end
    end

    def self.find_by_key(key)
      self.class_variable_set :@@find_by_key, key
    end

    def find_by_key
      self.class.class_variable_defined?(:@@find_by_key) ? self.class.class_variable_get(:@@find_by_key) : :id
    end

  end

  def resource_name
    self.class.resource_name
  end

  def resource_class
    self.class.resource_class
  end

  def set_resource key, val
    instance_variable_set key, val
    @resource = val
  end

  def resource_scope
    resource_class
  end

  def resource_params
    params[resource_name.singularize]
  end

  def resource_count
    resource_class.present? ? resource_class.all.size : resource.size
  end

  def resource_count_label
    resource_class.present? ? resource_class.all.size : resource.size
  end

  def resource opts={}
    authorize = opts.delete(:authorize)
    action = params[:action]

    unless @resource.nil?
      authorize @resource, :"#{action}?" if authorize
      return @resource
    end

    return nil if resource_class.nil?

    class_scope = policy_scope(resource_scope)

    return if class_scope.nil?

    case action
    when 'new', 'create'
      key = :"@#{resource_name.singularize}"
      unless results = instance_variable_get(key)
        set_resource(key, results = resource_class.new)
      end
    when 'index'
      key = :"@#{resource_name}"

      unless results = instance_variable_get(key)
        set_resource(key, results = class_scope)
      end
    else
      if params[:id].present?
        key = :"@#{resource_name.singularize}"
        unless results = instance_variable_get(key)
          q = resource_scope.where(find_by_key => params[:id])
          set_resource(key, results = q.first)
        end
      else
        key = :"@#{resource_name}"
        unless results = instance_variable_get(key)
          set_resource(key, results = class_scope)
        end
      end
    end
    authorize results, :"#{action}?" if authorize && results
    raise ActiveRecord::RecordNotFound if results.nil?
  end
  alias_method :load_resource, :resource

  def controller_namespace
    []
  end

  def resource_path_for res, action=nil, namespace=[]
    plural = resource_name.to_sym
    singular = resource_name.singularize.to_sym

    if action.present?
      action = action.to_s
    else
      action = params[:action]
    end

    case action
    when 'update' then controller_namespace + namespace + [res]
    when 'create' then controller_namespace + namespace + [plural]
    when 'index' then controller_namespace + namespace + [plural]
    when 'destroy' then controller_namespace + namespace + [res]
    when 'show' then controller_namespace + namespace + [res]
    when 'new' then [:new] + controller_namespace + namespace + [singular]
    else
      if res.is_a?(ActiveRecord::Relation)
        [action.to_sym] + controller_namespace + namespace + [plural]
      else
        [action.to_sym] + controller_namespace + namespace + [res]
      end
    end
  end

  def resource_location(*args)
    case action_name
    when 'create' then controller_namespace << resource
    when 'update' then controller_namespace << resource
    else
      controller_namespace << resource_name.to_s.pluralize.to_sym
    end
  end

  def resource_path action=nil, resource=nil
    resource_path_for resource || self.resource, action
  end

  def route_exists_for?(action, record=nil)
    route_exist = true
    begin
      polymorphic_url(resource_path(action, record))
    rescue => e
      TPrint.debug e
      TPrint.debug e.backtrace
      route_exist = false
    end
    route_exist
  end
end
