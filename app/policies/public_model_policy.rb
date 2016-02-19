class PublicModelPolicy < AdminPolicy
  def show?
    true
  end

  def index?
    true
  end
end
