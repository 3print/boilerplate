class PublicSourceModelPolicy < PublicModelPolicy
  def create?
    true
  end

  def new?
    true
  end
end
