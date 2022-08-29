# frozen_string_literal: true

class CargosController < ApplicationController
  before_action :authenticate_user!
  def index
    @cargos = Cargo.all
  end

  def show
    @cargo = Cargo.find(params[:id])
  end

  def new
    @cargo = Cargo.new
  end

  def create
    extended_params = Package::Builder.cargo_information(cargo_params)
    @cargo = Cargo.new(extended_params)

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
                                  :destinations).merge(user: current_user)
  end
end
