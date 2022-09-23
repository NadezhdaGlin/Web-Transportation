# frozen_string_literal: true

class CargosController < ApplicationController

  def index
    @cargos = if params[:sort].present?
                current_user.cargos.order("#{params[:sort]} #{params[:direction]}").page(params[:page])
              else
                current_user.cargos.page(params[:page])
              end
  end

  def show
    @cargo = current_user.cargos.find(params[:id])
  end

  def new
    @cargo = Cargo.new
  end

  def create
    outcome = Cargos::CreateCargo.run(params[:cargo].merge(user: current_user))
    if outcome.valid?
      redirect_to(outcome.result)
    else
      redirect_to new_cargo_path
    end
  end

  def edit
    @cargo = Cargo.find(params[:id])
  end

  def update
    cargo = Cargo.find(params[:id])
    outcome = Cargos::UpdateCargo.run(params[:cargo].merge(user: current_user, cargo: cargo))
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
