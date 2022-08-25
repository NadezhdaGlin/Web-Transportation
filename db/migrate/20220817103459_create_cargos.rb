# frozen_string_literal: true

class CreateCargos < ActiveRecord::Migration[7.0]
  def change
    create_table :cargos do |t|
      t.text :name, null: false
      t.text :surname, null: false
      t.text :middle_name, null: false
      t.string :phone, null: false
      t.text :email, null: false
      t.float :weight, null: false
      t.integer :length, null: false
      t.integer :width, null: false
      t.integer :height, null: false
      t.text :origins, null: false
      t.text :destinations, null: false
      t.float :distance, null: false
      t.integer :price, null: false

      t.timestamps
    end
  end
end
