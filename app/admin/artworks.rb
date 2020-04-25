# frozen_string_literal: true

ActiveAdmin.register Artwork do
  permit_params :name, :description, :published, :keyword_ids, :standard_color, :standard_material, :standard_size, :standard_sold_per,
  :feature_sets, :standard_price, :feature_set_id, images: []
  config.batch_actions = false

  filter :name
  filter :description
  filter :standard_price
  filter :created_at
  filter :published
  filter :keywords

  controller do
    def create
      @artwork = current_admin_user.artworks.new(permitted_params[:artwork])
      @feature_set = FeatureSet.new(artwork: @artwork)

      @feature_set.color = if params[:artwork][:feature_sets][:color] == "#000000"
        @artwork.standard_color == "#000000" ? nil : @artwork.standard_color
      else
        params[:artwork][:feature_sets][:color]
      end
      @feature_set.material = params[:artwork][:feature_sets][:material].empty? ? @artwork.standard_material : params[:artwork][:feature_sets][:material]
      @feature_set.price = params[:artwork][:feature_sets][:price].empty? ? @artwork.standard_price : params[:artwork][:feature_sets][:price]
      @feature_set.size = params[:artwork][:feature_sets][:size].empty? ? @artwork.standard_size : params[:artwork][:feature_sets][:size]
      @feature_set.sold_per = params[:artwork][:feature_sets][:sold_per].empty? ? @artwork.standard_sold_per : params[:artwork][:feature_sets][:sold_per]
      @feature_set.pieces_available = params[:artwork][:feature_sets][:pieces_available].empty? ? 1 : params[:artwork][:feature_sets][:pieces_available]
      @feature_set.save!

      transaction_notice = "Het kunstwerk werk correct toegevoegd."
      create!(notice: transaction_notice) { admin_artworks_path }
    end

    def update
      @artwork = Artwork.find(params[:id])
      unless params[:artwork][:images].nil?
        @artwork.images.attach(params[:artwork][:images])
      end
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

  action_item "Bewerk kunstwerk", only: :show do
    link_to "Maak kenmerken set aan" , new_admin_artwork_feature_set_path(artwork.id)
end

  index do
    column :id
    column :name do |artwork|
      div(style: "width:200px;") do
        artwork.name
      end
    end
    column :total_amount do |artwork|
      artwork.total_amount == 0 ? "Uitverkocht" : artwork.total_amount
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
    column :standard_price do |artwork|
      number_to_currency(artwork.standard_price)
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
            row :total_amount do |artwork|
              artwork.total_amount == 0 ? "Uitverkocht" : artwork.total_amount
            end
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
            row :standard_price do |artwork|
              number_to_currency(artwork.standard_price)
            end
            row :standard_color do |feature_set|
              color_field(feature_set, feature_set.standard_color, value: feature_set.standard_color)
            end
            row :standard_sold_per
            row :standard_size
            row :standard_material
          end
        end

        panel "Bekijk de beschikbare kenmerk-sets" do
          table_for resource.feature_sets do |feature_set|
            # column :color, type: :color_field
            column :color do |feature_set|
              color_field(feature_set, feature_set.color, value: feature_set.color)
            end
            column :sold_per
            column :size
            column :material
            column :price do |feature_set|
              number_to_currency(feature_set.price)
            end
            column :pieces_available do |feature_set|
              feature_set.pieces_available == 0 ? "Uitverkocht" : feature_set.pieces_available
            end
            column :active do |feature_set|
              div do
                if feature_set.active
                  status_tag "Ja", class: "green"
                else
                  status_tag "Nee", class: "red"
                end
              end
            end
            column "Links" do |feature_set|
              span link_to "Bekijk", admin_artwork_feature_set_path(resource.id, feature_set.id)
              span link_to "Wijzig", edit_admin_artwork_feature_set_path(resource.id, feature_set.id)
              span link_to "Verwijder", admin_artwork_feature_set_path(resource.id, feature_set.id), method: :delete, data: { confirm: 'Wil je deze kenmerken set verwijderen?' }
              if feature_set.active?
              span link_to "Maak inactief", set_as_inactive_admin_artwork_feature_set_path(resource.id, feature_set.id), method: :patch
              else
                span link_to "Maak actief", make_active_admin_artwork_feature_set_path(resource.id, feature_set.id), method: :patch
              end
            end
          end
        end
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :published, as: :select, collection: [[:ja, true], [:nee, false]], include_blank: false
      f.input :description
      f.input :images, as: :file, input_html: { multiple: true }, hint: "Er kunnen meerdere foto's geselecteerd worden door de control-toets ingedrukt te houden"

      hint = "Gekozen categorieën worden toegevoegd en zijn geen vervanging van de bestaande categorieën. " unless resource.id.nil?
      info = "Er kunnen meerdere categorieën geselecteerd worden door de control-toets ingedrukt te houden."
      hint_info = hint.nil? ? info : hint + info
      f.input :keywords, hint: hint_info

      f.li h3 "De standaard categorieën worden gebruikt indien deze in een kenmerken set niet zijn opgegeven:"
      f.input :standard_color
      f.input :standard_material
      f.input :standard_price
      f.input :standard_size, hint: "In centimeter"
      f.input :standard_sold_per
    end

    panel "Huidige foto's" do
      artwork.images.each do |image|
        span cl_image_tag image.key, height: 200, width: 200, crop: :fill
        span link_to "<- Verwijder", delete_category_image_admin_artwork_path(image.id), method: :delete, data: { confirm: 'Are you sure?' }
      end
    end

    if params[:action] == "new"
      panel "Kenmerken sets" do
        h3 "Maak alvast je eerste feature set aan:"
        f.fields_for :feature_sets, FeatureSet.new(artwork: artwork) do |g|
          g.inputs do
            g.input :color
            g.input :material
            g.input :price
            g.input :size, hint: "In centimeter"
            g.input :sold_per
            g.input :pieces_available
            g.input :active
          end
        end
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
