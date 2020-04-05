# frozen_string_literal: true

ActiveAdmin.register ArtworkKeyword do
  menu false

  actions :destroy, :create

  permit_params :keyword_id, :artwork_id
  
  controller do
    def create
      @artwork_keyword = ArtworkKeywords.new(permitted_params[:artwork_keywords])

      transaction_notice = "De category werd correct toegevoegd."
      create!(notice: transaction_notice) { admin_artwork_path(@artwork_keyword.artwork.id) }
    end

    def destroy
      @artwork_keyword = ArtworkKeyword.find(params[:id])
      if @artwork_keyword.destroy
        redirect_to admin_artwork_path(@artwork_keyword.artwork.id), notice: "Categorie werd verwijderd." 
      else
        return redirect_to admin_artwork_path(@artwork_keyword.artwork.id), alert: @artwork_keyword.errors.full_messages.to_sentence
      end
    end
  end
end