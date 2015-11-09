class PublicModelPolicy < AdminPolicy
  def show?
    true
  end

  def index?
    true
  end

  def create?
    true
  end

  def handle?
    user && user.admin?
  end

  def unhandle?
    user && user.admin?
  end
end
