# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!
  def index
    redirect_to cargos_path
  end

  def show
    @user = User.find(params[:id])
    authorize @user
    if current_user.is_organization_admin? && Cargo.org_by(current_user.organization.id).present?
      org_id = @user.organization.id
      @widgets = [
        Cargos::CountWidget.call(org_id),
        Cargos::CountWidget.call(org_id, :sorted),
        Cargos::PriceWidget.call(org_id),
        Cargos::PriceWidget.call(org_id, :average),
        Cargos::DistanceWidget.call(org_id),
        Cargos::DistanceWidget.call(org_id, :max)
      ]
    end
  end
end
