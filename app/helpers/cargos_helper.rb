# frozen_string_literal: true

module CargosHelper
  def sortable(column, title = nil)
    title ||= column
    direction = column == sort_column && sort_direction == 'asc' ? 'desc' : 'asc'
    link_to title, { sort: column, direction: direction }
  end
  
  def sort_column
    Cargo.column_names.include?(params[:sort]) ? params[:sort] : 'price'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end
end
