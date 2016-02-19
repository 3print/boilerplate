
class UserPolicy < AdminPolicy
  def show?
    only_admin || user == record
  end

  def edit?
    only_super_admin || (only_admin && !record.super_admin?) || user == record
  end

  def update?
    only_super_admin || (only_admin && !record.super_admin?) || user == record
  end

  def destroy?
    (only_super_admin || (only_admin && !record.super_admin?)) && user != record
  end

  def masquerade?
    only_super_admin && user != record
  end
end
