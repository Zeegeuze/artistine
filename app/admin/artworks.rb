# frozen_string_literal: true

ActiveAdmin.register Artwork do
  permit_params :name, :description, :price, :photo
  config.batch_actions = false

  controller do
    def create
      @artwork = current_admin_user.artworks.new(permitted_params[:artwork])

      transaction_notice = "Het kunstwerk werk correct toegevoegd."
      create!(notice: transaction_notice) { admin_artworks_path }
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
    column :name
    column :published do |artwork|
      if artwork.published
        status_tag "Ja", class: "green"
      else
        status_tag "Nee", class: "red"
      end
    end
    column "Zichtbaar / onzichtbaar" do |artwork|
      if artwork.published
        button_to "Maak onzichtbaar", remove_published_admin_artwork_path(artwork.id), method: :patch
      else
        button_to "Maak zichtbaar", set_as_published_admin_artwork_path(artwork.id), method: :patch
      end
    end
    column :price do |artwork|
      number_to_currency(artwork.price)
    end
    column :description
    column :created_at
    actions
  end
  
  show do
    
  columns do
    column do
      panel "Photo's", style: "text-align: center" do
        cl_image_tag  artwork.photo, height: 400, width: 400, crop: :fill unless artwork.photo.nil?
      end
    end
    column do
      panel "Specificaties" do
        attributes_table_for artwork do
          row :name
          row :published do |artwork|
            if artwork.published
              status_tag "Ja", class: "green"
            else
              status_tag "Nee", class: "red"
            end
          end
          row " " do |artwork|
            if artwork.published
                button_to "Maak onzichtbaar", remove_published_admin_artwork_path, method: :patch
            else
                button_to "Maak zichtbaar", set_as_published_admin_artwork_path, method: :patch
            end
          end
          row :price do |artwork|
            number_to_currency(artwork.price)
          end
        end
      end
      panel "Korte samenvatting" do
        attributes_table_for artwork do
          row :description
        end
      end
    end


      # panel "Opmerkingen van collega's binnen volgende bibliotheek verbanden: #{current_user.library_associations.map { |l_a| l_a.name }.uniq.join(', ')}" do
      #   book.book_comments.each do |b_c|
      #     if b_c.visible_for?(current_user)
      #       div do
      #         b_c.comment
      #       end
      # 
      #       div do
      #         strong do
      #           b_c.user.name
      #         end
      #       end
      #       br
      #     else
      #       "Er zijn nog geen opmerkingen toegevoegd."
      #     end
      #   end
      #   active_admin_form_for [ :bib, book.book_comments.new ] do |f|
      #     f.inputs do
      #       f.hidden_field :book_id
      #       f.input :comment, label: false, input_html: {rows: 4, style: "width: 95%"}
      #       f.li "Opmerkingen zijn zichtbaar voor iedereen in je bibliotheek of bibliotheekverband."
      #     end
      #     f.submit "Plaats opmerking"
      #   end
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :published, as: :select, collection: [[:ja, true], [:nee, false]]
      f.input :price
      f.input :description
      f.input :photo, as: :file
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
end
