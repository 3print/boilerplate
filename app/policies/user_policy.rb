
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

end
