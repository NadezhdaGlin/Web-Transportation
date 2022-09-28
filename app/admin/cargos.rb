# frozen_string_literal: true

ActiveAdmin.register Cargo do
  permit_params :name, :surname, :middle_name, :phone, :email, :weight, :length, :width, :height, :origins,
                :destinations, :distance, :price, :user_id, :status

  form do |f|
    f.inputs do
      f.input :name
      f.input :surname
      f.input :middle_name
      f.input :phone
      f.input :email
      f.input :weight
      f.input :length
      f.input :width
      f.input :height
      f.input :origins
      f.input :destinations
      f.input :status,
        as: :select, 
        collection: resource.aasm.states(permitted: true)
          .map { |state| state.name.to_s }
          .append(resource.aasm.current_state.to_s), 
        include_blank: false
    end
    f.actions
  end

  controller do
    def edit
      @cargo = Cargo.find(permitted_params[:id])  
    end
  
    def update
      @cargo = Cargo.find(permitted_params[:id])
      @cargo.assign_attributes(permitted_params[:cargo])

      if required_to_recalculate?(@cargo) 
        updated_params = Package::Builder.cargo_information(permitted_params[:cargo])
        @cargo.update(updated_params)
        redirect_to admin_cargo_path
      else
        @cargo.save
        redirect_to admin_cargo_path
      end
    end

    private

    def required_to_recalculate?(cargo)
      cargo.weight_changed? || cargo.length_changed? || cargo.width_changed? || 
        cargo.height_changed? || cargo.origins_changed? || cargo.destinations_changed? 
    end
  end
end
