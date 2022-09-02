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
    extended_params = Package::Builder.cargo_information(cargo_params)
    @cargo = current_user.cargos.new(extended_params)

    if @cargo.save
      redirect_to @cargo
    else
      render :new
    end
  end

  private

  def cargo_params
    params.require(:cargo).permit(:name, :surname, :middle_name, :phone, :email, :weight, :length, :width,
                                  :height,
                                  :origins,
                                  :destinations)
  end
end
