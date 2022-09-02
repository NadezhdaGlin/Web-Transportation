# frozen_string_literal: true

ActiveAdmin.register Cargo do
  permit_params :name, :surname, :middle_name, :phone, :email, :weight, :length, :width, :height, :origins,
                :destinations, :distance, :price, :user_id
end
