# frozen_string_literal: true

module Cargos
  class CreateCargo < ActiveInteraction::Base
    string :name, :surname, :middle_name, :phone, :email,
           :origins, :destinations
    float :weight
    integer :length, :width, :height
    object :user
    validates :name,
              :surname,
              :middle_name,
              :phone,
              :email,
              :weight,
              :length,
              :width,
              :height,
              :origins,
              :destinations,
              :user,
              presence: true
    validates :phone, format: { with: /(^\+?[(]?[0-9]{3}[)]?[-\s.]?[0-9]{3}[-\s.]?[0-9]{4,6}$)/ }

    def execute
      extended_params = Package::Builder.cargo_information(inputs_params)
      cargo = Cargo.create(extended_params)
    end

    private

    def inputs_params
      inputs.slice(:name, :surname, :middle_name, :phone, :email, :weight,
                   :length, :width, :height, :origins, :destinations, :user)
    end
  end
end
