# frozen_string_literal: true

ActiveAdmin.register Artwork do
  permit_params :name, :description, :price, images: []
  config.batch_actions = false

  filter :name
  filter :description
  filter :price
  filter :created_at
  filter :published
  filter :keywords

  controller do
    def create
      @artwork = current_admin_user.artworks.new(permitted_params[:artwork])

      transaction_notice = "Het kunstwerk werk correct toegevoegd."
      create!(notice: transaction_notice) { admin_artworks_path }
    end

    def update
      @artwork = Artwork.find(params[:id])
      @artwork.images.attach(params[:artwork][:images])
      if params[:artwork][:keyword_ids].present?
        keyword_ids = params[:artwork][:keyword_ids]
        keyword_ids.each do |keyword_id|
          if keyword_id.present?
            @artwork.keywords << (Keyword.find keyword_id)
          end
        end
      end
      @artwork.keywords = @artwork.keywords.uniq

      @artwork.save!
      redirect_to admin_artworks_path, notice: "#{@artwork.name} werd correct gewijzigd."
    end
  end

  config.clear_action_items!

  action_item only: :index do
      link_to "Nieuw kunstwerk" , "/admin/artworks/new" 
  end

  action_item "Bewerk kunstwerk", only: :show do
      link_to "Bewerk kunstwerk" , edit_admin_artwork_path()
  end

  index do
    column :id
    column :name do |artwork|
      div(style: "width:200px;") do
        artwork.name
      end
    end
    column :published do |artwork|
      if artwork.published
        status_tag "Ja", class: "green"
      else
        status_tag "Nee", class: "red"
      end
    end
    column "Zichtbaar / onzichtbaar" do |artwork|
      if artwork.published
        button_to "Maak onzichtbaar", remove_published_admin_artwork_path(artwork.id), method: :patch, class: "button--red"
      else
        button_to "Maak zichtbaar", set_as_published_admin_artwork_path(artwork.id), method: :patch, class: "button--green"
      end
    end
    column :price do |artwork|
      number_to_currency(artwork.price)
    end
    column :description
    column :created_at
    column "Opmerkingen" do |artwork|
      if artwork.remarks.exists?
        link_to "Bekijk", admin_remarks_url(q: { artwork_id_equals: artwork.id })
      else
        "-"
      end
    end
    actions
  end
  
  show do
    columns do
      column do
        panel "Foto's", style: "text-align: center" do
          artwork.images.each do |image|
            span cl_image_tag image.key, height: 200, width: 200, crop: :fill
            span link_to "<- Verwijder", delete_category_image_admin_artwork_path(image.id), method: :delete, data: { confirm: 'Wil je deze foto verwijderen?' }
          end
        end
      end
      column do
        panel "Specificaties" do
          attributes_table_for artwork do
            row :name
            row :published do |artwork|
              div do
                if artwork.published
                  status_tag "Ja", class: "green"
                else
                  status_tag "Nee", class: "red"
                end
              end
              br
              div do
                if artwork.published
                    button_to "Maak onzichtbaar", remove_published_admin_artwork_path, method: :patch, class: "button--red"
                else
                    button_to "Maak zichtbaar", set_as_published_admin_artwork_path, method: :patch, class: "button--green"
                end
              end
            end
            row :price do |artwork|
              number_to_currency(artwork.price)
            end
            row :keywords do |artwork|
              ul do
                artwork.keywords.each do |keyword|
                  columns do
                    column do
                      li link_to keyword.name, admin_keyword_path(keyword.id)
                    end
                    column do
                      @artwork_keyword = ArtworkKeyword.where(artwork: artwork, keyword: keyword).first
                      link_to "Verwijder", admin_artwork_keyword_path(@artwork_keyword.id), 
                                           class: "remove_artwork_keyword_#{@artwork_keyword.id}",
                                           method: :delete, 
                                           data: { confirm: 'Wil je deze categorie verwijderen?' }
                    end
                  end
                end
              end
              columns do
                column do
                  button_to "Bestaande categorie toevoegen", edit_admin_artwork_path(artwork.id), method: :get
                end
                column do
                  button_to "Nieuwe categorie aanmaken", new_admin_keyword_path, method: :get
                end
              end
            end
          end
        end
        panel "Korte samenvatting" do
          attributes_table_for artwork do
            row :description
          end
        end
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :published, as: :select, collection: [[:ja, true], [:nee, false]]
      f.input :price
      f.input :description
      f.input :images, as: :file, input_html: { multiple: true }
      f.input :keywords
    end

    panel "Huidige foto's" do
      artwork.images.each do |image|
        span cl_image_tag image.key, height: 200, width: 200, crop: :fill
        span link_to "<- Verwijder", delete_category_image_admin_artwork_path(image.id), method: :delete, data: { confirm: 'Are you sure?' }
      end
    end
    f.actions
  end  

  member_action :set_as_published, method: :patch do
    resource.update! published: true
    redirect_back fallback_location: admin_artwork_path(resource), notice: "Kunstwerk werd online geplaatst"
  end

  member_action :remove_published, method: :patch do
    resource.update! published: false
    redirect_back fallback_location: admin_artwork_path(resource), notice: "Kunstwerk is niet meer zichtbaar"
  end

  member_action :delete_category_image, method: :delete do
    @image = ActiveStorage::Attachment.find(params[:id])
    @image.purge_later
    redirect_back(fallback_location: admin_artworks_path)   
  end
end
