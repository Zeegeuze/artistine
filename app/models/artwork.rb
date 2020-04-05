# frozen_string_literal: true

class Artwork < ApplicationRecord
  has_many_attached :images

  scope :with_eager_loaded_images, -> { eager_load(images_attachments: :blob) }

  has_many :remarks, inverse_of: :artwork
  has_many :artwork_keywords, inverse_of: :artwork, dependent: :destroy
  has_many :keywords, through: :artwork_keywords

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
