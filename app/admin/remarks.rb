# frozen_string_literal: true

ActiveAdmin.register Remark do
  # permit_params :body, artwork_attributes: [], user_attributes: []
  config.batch_actions = false

  filter :artwork
  filter :user
  filter :created_at
end
