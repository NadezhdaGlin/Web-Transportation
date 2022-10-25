# frozen_string_literal: true

class CargosController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.is_organization_admin?
      @cargos = Cargo.where(user_id: current_user.organization.users.ids).page(params[:page])
      @users = current_user.organization.users
    else
      @cargos = Cargo.where(user_id: current_user.id).page(params[:page])
    end

    @cargos = @cargos.rewhere(user_id: params[:operator_id_filter]) if params[:operator_id_filter].present?
    @cargos = @cargos.order("#{params[:sort]} #{params[:direction]}") if params[:sort].present?

    authorize @cargos
  end

  def show
    @cargo = Cargo.find(params[:id])
    authorize @cargo
  end

  def new
    @cargo = Cargo.new
    authorize @cargo
  end

  def create
    authorize Cargo
    outcome = Cargos::CreateCargo.run(params[:cargo].merge(user: current_user))
    if outcome.valid?
      redirect_to(outcome.result)
    else
      redirect_to new_cargo_path
    end
  end

  def edit
    @cargo = Cargo.find(params[:id])
    authorize @cargo
  end

  def update
    cargo = Cargo.find(params[:id])
    authorize cargo
    outcome = Cargos::UpdateCargo.run(params[:cargo].merge(cargo: cargo))
    if outcome.valid?
      redirect_to(outcome.result)
    else
      redirect_to edit_cargo_path
    end
  end

  def destroy
    cargo = Cargo.find(params[:id])
    Cargos::DestroyCargo.run(cargo: cargo) if current_user == cargo.user
    redirect_to(cargos_path)
  end
end
