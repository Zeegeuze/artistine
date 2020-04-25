# frozen_string_literal: true

ActiveAdmin.register FeatureSet do
  belongs_to :artwork

  menu false

  permit_params :artwork_id, :color, :material, :pieces_available, :price, :sold_per, :size, :active
  
  controller do
    def create
      @feature_set = FeatureSet.new(permitted_params[:feature_set])
      @artwork = Artwork.find params[:feature_set][:artwork_id]

      @feature_set.color = if params[:feature_set][:color] == "#000000"
        @artwork.standard_color == "#000000" ? nil : @artwork.standard_color
      else
        params[:feature_set][:color]
      end
      @feature_set.material = params[:feature_set][:material].empty? ? @artwork.standard_material : params[:feature_set][:material]
      @feature_set.price = params[:feature_set][:price].empty? ? @artwork.standard_price : params[:feature_set][:price]
      @feature_set.size = params[:feature_set][:size].empty? ? @artwork.standard_size : params[:feature_set][:size]
      @feature_set.sold_per = params[:feature_set][:sold_per].empty? ? @artwork.standard_sold_per : params[:feature_set][:sold_per]
      @feature_set.pieces_available = params[:feature_set][:pieces_available].empty? ? 1 : params[:feature_set][:pieces_available]

      create! do
        if resource.valid?
          redirect_to admin_artwork_path(resource.artwork.id), notice: "De nieuwe kenmerken set werd aangemaakt"
          return
        else
          redirect_back fallback_location: default_fallback_location, alert: "Opgelet: er is iets fout gegaan: de kenmerken set is niet aangemaakt."
          return
        end
      end
    end

    def update
      @feature_set = FeatureSet.find params[:id]
      @artwork = @feature_set.artwork

      @feature_set.color = if params[:feature_set][:color] == "#000000"
        @artwork.standard_color == "#000000" ? nil : @artwork.standard_color
      else
        params[:feature_set][:color]
      end
      @feature_set.material = params[:feature_set][:material].empty? ? @artwork.standard_material : params[:feature_set][:material]
      @feature_set.price = params[:feature_set][:price].empty? ? @artwork.standard_price : params[:feature_set][:price]
      @feature_set.size = params[:feature_set][:size].empty? ? @artwork.standard_size : params[:feature_set][:size]
      @feature_set.sold_per = params[:feature_set][:sold_per].empty? ? @artwork.standard_sold_per : params[:feature_set][:sold_per]
      @feature_set.pieces_available = params[:feature_set][:pieces_available].empty? ? 1 : params[:feature_set][:pieces_available]

      if @feature_set.save!
        redirect_to admin_artwork_path(resource.artwork.id), notice: "De nieuwe kenmerken set werd aangepast"
        return
      else
        redirect_back fallback_location: default_fallback_location, alert: "Opgelet: er is iets fout gegaan: de kenmerken set is niet aangepast."
        return
      end
    end

    def destroy
      destroy! do |format|
        format.html do
          redirect_back fallback_location: default_fallback_location
        end
      end
    end
  end

  form do |f|
    f.inputs do
      f.li h2 "Kunstwerk: #{ artwork.name }"
      f.hidden_field :artwork_id
      f.input :color
      f.input :material
      f.input :price
      f.input :size, hint: "In centimeter"
      f.input :sold_per
      f.input :pieces_available
      f.input :active
    end

    f.actions
  end

  member_action :set_as_inactive, method: :patch do
    resource.update! active: false
    redirect_back fallback_location: admin_artwork_path(resource.artwork.id), notice: "Kenmerken set is niet meer actief"
  end

  member_action :make_active, method: :patch do
    resource.update! active: true
    redirect_back fallback_location: admin_artwork_path(resource.artwork.id), notice: "Kenmerken set is actief"
  end
end