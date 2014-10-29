
class UserPolicy < AdminPolicy

  def show?
    user.admin? || user == record
  end

  def edit?
    user.admin? || user == record
  end

  def update?
    user.admin? || user == record
  end

  def approve?
    user.admin?
  end

  def revocate?
    user.admin?
  end

end
