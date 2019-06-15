ActiveAdmin.register Beer do
  permit_params :name, :abv, :ibu, :description, :image

  form do |f|
    f.semantic_errors # shows errors on :base
    f.inputs do
      f.input :name
      f.input :abv
      f.input :ibu
      f.input :description
      f.input :image, as: :file
      f.actions
    end
  end

  show do
    attributes_table do
      row :name
      row :abv
      row :ibu
      row :description
      row :image do |ad|
        image_tag url_for(ad.image)
      end
      active_admin_comments
    end
  end
end
