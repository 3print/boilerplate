class AdminPolicy
  attr_reader :user, :record

  def initialize(user, record)
    raise Pundit::NotAuthorizedError, "must be logged in" unless user

    @user = user
    @record = record
  end

  def method_missing name, *args, &block
    if name =~ /.*\?/
      edit?
    end
  end

  def index?
    only_admin
  end

  def show?
    scope.where(:id => record.id).exists?
  end

  def create?
    only_admin
  end

  def new?
    create?
  end

  def update?
    only_admin
  end

  def edit?
    update?
  end

  def destroy?
    only_admin
  end

  def handle?
    only_admin
  end

  def unhandle?
    only_admin
  end

  def publish?
    only_admin
  end

  def unpublish?
    only_admin
  end

  def save_sequence?
    only_admin
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end
  end

  # Attributes

  def view? (attribute)
    true
  end

  def modify? (attribute)
    only_admin?
  end

protected

  def only_admin
    user && user.admin?
  end

  def only_super_admin
    user && user.super_admin?
  end
end
