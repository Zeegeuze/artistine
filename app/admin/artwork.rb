# frozen_string_literal: true

ActiveAdmin.register Artwork do

  permit_params :name, :description, :price

  index do
    column :id
    column :name
    column :price do |cbl|
      number_to_currency(cbl.price)
    end
    column :description
    column :created_at
    actions
  end
  
  show do
    attributes_table do
      row :name
      row :price do |cbl|
        number_to_currency(cbl.price)
      end
      row :description
    end
  end
end
