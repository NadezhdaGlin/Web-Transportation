class AddStatusToCargos < ActiveRecord::Migration[7.0]
  def change
    add_column :cargos, :status, :string
  end
end
