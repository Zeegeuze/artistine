# frozen_string_literal: true

ActiveAdmin.register Keyword do
  permit_params :name, :publish_on_homepage, :extra_info

  controller do
    def create
      @keyword = Keyword.new(permitted_params[:keyword])

      transaction_notice = "De categorie werk correct toegevoegd."
      create!(notice: transaction_notice) { admin_keywords_path }
    end

    def update
      @keyword = Keyword.find(params[:id])
      if params[:keyword][:artwork_ids].present?
        artwork_ids = params[:keyword][:artwork_ids]
        artwork_ids.each do |artwork_id|
          if artwork_id.present?
            @keyword.artworks << (Artwork.find artwork_id)
          end
        end
        @keyword.artworks = @keyword.artworks.uniq
      end

      update!(notice: "Categorie '#{@keyword.name}' werd correct gewijzigd.") do
        admin_keywords_path
      end
    end
  end

  index do
    selectable_column

    column :name
    column :publish_on_homepage do |keyword|
      if keyword.publish_on_homepage
        status_tag "Ja", class: "green"
      else
        status_tag "Nee", class: "red"
      end
    end
    actions
  end

  show do
    panel "Eigenschappen" do
      attributes_table_for keyword do
        row :publish_on_homepage do |keyword|
          if keyword.publish_on_homepage
            status_tag "Ja", class: "green"
          else
            status_tag "Nee", class: "red"
          end
        end
        row :created_at
        row :updated_at
        row :extra_info
      end
    end

    panel "Gebruikt voor volgende kunstwerken" do
      if resource.artworks.empty?
        "Er zijn nog geen kustwerken gelinkt aan deze categorie."
      else
        table_for resource.artworks do
          column :name
          column :published do |artwork|
            div do
              if artwork.published
                status_tag "Ja", class: "green"
              else
                status_tag "Nee", class: "red"
              end
            end
          end
          column :standard_price do |artwork|
            number_to_currency(artwork.standard_price)
          end
            
          column "Links" do |artwork|
            @artwork_keyword = ArtworkKeyword.where(artwork: artwork, keyword: resource).first
            
            span link_to "Verwijder", admin_artwork_keyword_path(@artwork_keyword.id), 
            class: "remove_artwork_keyword_#{@artwork_keyword.id}",
            method: :delete, 
            data: { confirm: 'Wil je deze categorie verwijderen?' }

            span link_to "Aanpassen", edit_admin_artwork_path(artwork.id)
          end
        end
      end
      div do
        button_to "Voeg kunstwerk toe", edit_admin_keyword_path(resource.id), method: :get
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :extra_info, input_html: {rows: 4}
      f.input :publish_on_homepage

      hint = "Gekozen kunstwerken worden toegevoegd en zijn geen vervanging van de bestaande kunstwerken. " unless resource.id.nil?
      info = "Er kunnen meerdere kunstwerken geselecteerd worden door de control-toets ingedrukt te houden."
      hint_info = hint.nil? ? info : hint + info
      f.input :artworks, hint: hint_info

      li do
        panel "Categorie '#{resource.name}' wordt reeds gebruikt voor volgende kunstwerken" do
          if resource.artworks.empty?
            "Er zijn nog geen kustwerken gelinkt aan deze categorie."
          else
            table_for resource.artworks do
              column :name
              column :published do |artwork|
                div do
                  if artwork.published
                    status_tag "Ja", class: "green"
                  else
                    status_tag "Nee", class: "red"
                  end
                end
              end
              column :standard_price do |artwork|
                number_to_currency(artwork.standard_price)
              end                
              column "Links" do |artwork|
                @artwork_keyword = ArtworkKeyword.where(artwork: artwork, keyword: resource).first
                
                span link_to "Verwijder", admin_artwork_keyword_path(@artwork_keyword.id), 
                class: "remove_artwork_keyword_#{@artwork_keyword.id}",
                method: :delete, 
                data: { confirm: 'Wil je deze categorie verwijderen?' }
              end
            end
          end
        end
      end
    end
    f.actions
  end
end