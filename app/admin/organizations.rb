ActiveAdmin.register Organization do
  permit_params :name_org
  form do |f|
    f.inputs do
      f.inputs :name_org
    end
    f.actions
  end
end