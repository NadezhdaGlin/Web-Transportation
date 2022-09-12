# frozen_string_literal: true
class Cargo < ApplicationRecord
  include AASM

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
  validates :phone, format: { with: /(^\+?[(]?[0-9]{3}[)]?[-\s.]?[0-9]{3}[-\s.]?[0-9]{4,6}$)/ }
  belongs_to :user

  aasm column: :status do
    state :processing, initial: true
    state :delivering, :delivered

    event :cargo_processing do
      transitions from: :processing, to: :delivering
    end

    event :cargo_delivery do
      transitions from: :delivering, to: :delivered
    end   
  end
end
