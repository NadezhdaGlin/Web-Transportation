# frozen_string_literal: true

class Cargo < ApplicationRecord
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
            presence: true
  validates :phone, format: {with: /(^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$)/}
end
