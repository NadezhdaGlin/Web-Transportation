# frozen_string_literal: true

module Cargos
  class UpdateCargo < ActiveInteraction::Base
    string :name, :surname, :middle_name, :phone, :email,
           :origins, :destinations
    float :weight
    integer :length, :width, :height
    object  :cargo
    validates :cargo, presence: true
    validates :phone, format: { with: /(^\+?[(]?[0-9]{3}[)]?[-\s.]?[0-9]{3}[-\s.]?[0-9]{4,6}$)/ }

    def execute
      params = not_equal_inputs_params ? Package::Builder.cargo_information(inputs.to_h.except(:cargo)) : inputs.to_h.except(:cargo)
      cargo.update(params)
      cargo
    end

    private

    def not_equal_inputs_params
      cargo.weight != inputs[:weight] ||
        cargo.length != inputs[:length] ||
        cargo.width != inputs[:width] ||
        cargo.height != inputs[:height] ||
        cargo.origins != inputs[:origins] ||
        cargo.destinations != inputs[:destinations]
    end
  end
end
