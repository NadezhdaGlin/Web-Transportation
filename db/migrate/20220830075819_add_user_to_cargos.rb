# frozen_string_literal: true

class AddUserToCargos < ActiveRecord::Migration[7.0]
  def change
    add_reference :cargos, :user, null: false, foreign_key: true
  end
end
