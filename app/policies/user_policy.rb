
class UserPolicy < AdminPolicy
  def show?
    user.admin? || user == record
  end

  def edit?
    user.super_admin? || (user.admin? && !record.super_admin?) || user == record
  end

  def update?
    user.super_admin? || (user.admin? && !record.super_admin?) || user == record
  end

  def destroy?
    user.super_admin? || (user.admin? && !record.super_admin?)
  end

  def masquerade?
    user.super_admin?
  end
end
