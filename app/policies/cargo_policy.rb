class CargoPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    user.organization.present? && (user.organization == record.user.organization) && (user.id == record.user_id || user.is_organization_admin?)
  end

  def new
    user.organization.present?
  end

  def create?
    user.organization.present?
  end

  def edit?
    user.organization.present? && (user.organization == record.user.organization) && (user.id == record.user_id || user.is_organization_admin?)
  end

  def update?
    user.organization.present? && (user.organization == record.user.organization) && (user.id == record.user_id || user.is_organization_admin?)
  end
end
