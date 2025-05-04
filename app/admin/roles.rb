ActiveAdmin.register Role do
  config.sort_order = 'id_asc'
  config.filters = false

  index download_links: [:csv] do
    column :name
  end

  form do |f|
    f.inputs do
      f.input :name
    end
    f.actions
  end
end
