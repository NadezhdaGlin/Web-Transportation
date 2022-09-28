ActiveAdmin.register User do
  permit_params :role, :organization_id

  index do
    selectable_column
    id_column
    column :email
    column :role
    column :organization do |resource|
      resource&.organization&.name_org
    end
    actions
  end

  show do
    attributes_table do
      row :email
      row :role
      row :organization do |resource|
        resource&.organization&.name_org
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :role, as: :select, collection: ['operator', 'organization admin'], include_blank: false
      f.input :organization, as: :select, collection: Organization.all.collect {|org| [org.name_org, org.id]}, include_blank: false
    end
    f.actions
  end
end