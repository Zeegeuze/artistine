# frozen_string_literal: true

class Artwork < ApplicationRecord
  has_one_attached :photo
  
  mount_uploader :photo, PhotosUploader

  # def price(num)
  #   @view.number_to_currency(num)
  # end

end
