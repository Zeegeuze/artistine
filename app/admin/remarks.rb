# frozen_string_literal: true

ActiveAdmin.register Remark do
  # permit_params :body, artwork_attributes: [], user_attributes: []
  config.batch_actions = false

  actions :index, :show, :destroy

  permit_params :body, :user_id, :artwork_id, remark_attributes: [:id]

  filter :artwork
  filter :user
  filter :created_at

  index do
    Artwork.all.each do |artwork|
      unless artwork.remarks.empty?
        panel "#{artwork.name}", class: "artwork_#{artwork.id}" do
          columns do
            column do
              artwork.images.each do |image|
                span cl_image_tag image.key, height: 200, width: 200, crop: :fill
              end
            end
            column do
              artwork.remarks.each do |remark|
                panel "Opmerking van #{remark.created_at.to_date}", class: "remark_#{remark.id}" do
                  span remark.body
                  if remark.user
                    span "Door #{remark.user} "
                  end
                  br
                  br
                  span link_to "Verwijder", admin_remark_path(remark.id), method: :delete, data: { confirm: "Weet je het zeker?" }

                  panel "Antwoord", class: "answer_remarks_artwork_#{artwork.id}" do
                    if remark.answer_remarks.exists?
                      remark.answer_remarks.each do |a_r|
                        div do
                          div a_r.body
                          div link_to "Verwijder", admin_remark_answer_remark_path(remark, a_r.id), method: :delete, data: { confirm: "Weet je het zeker?" }
                        end
                        br
                      end
                    end

                    active_admin_form_for [ :admin, remark, remark.answer_remarks.new ] do |f|
                      div(style: "list-style: none") do
                        f.hidden_field :remark_id
                        f.input :body, as: :text, label: false, input_html: {rows: 4, style: "width: 100%"}
                        br
                        f.submit "Antwoord"
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end