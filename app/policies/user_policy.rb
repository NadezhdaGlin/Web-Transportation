class UserPolicy < ApplicationPolicy

  def show?
    user.organization.present? && 
    user.organization == record.organization &&
    user == record &&
    user.is_organization_admin?
  end
end