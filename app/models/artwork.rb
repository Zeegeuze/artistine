# frozen_string_literal: true

class Artwork < ApplicationRecord
  has_one_attached :image
  
  # mount_uploader :photo, PhotosUploader

  belongs_to :admin_user, inverse_of: :artworks

  validates :name, presence: true
  validates :description, presence: true

  # def price(num)
  #   @view.number_to_currency(num)
  # end

  def set_as_published!
    self.update published: true
  end

  def remove_published!
    self.update published: false
  end
end
