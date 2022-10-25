# frozen_string_literal: true

module Cargos
  class DestroyCargo < ActiveInteraction::Base
    object :cargo

    def execute
      cargo.destroy
    end
  end
end
