# frozen_string_literal: true

class Artwork < ApplicationRecord
  has_many_attached :images

  has_many :remarks, inverse_of: :artwork
  has_many :artwork_keywords, inverse_of: :artwork, dependent: :destroy
  has_many :feature_sets, dependent: :destroy, inverse_of: :artwork
  has_many :keywords, through: :artwork_keywords

  belongs_to :admin_user, inverse_of: :artworks

  validates :name, presence: true
  validates :description, presence: true
  # validates :pictures, presence: true if published?

  scope :with_eager_loaded_images, -> { eager_load(images_attachments: :blob) }

  scope :with_keyword, ->(keyword_id) { includes(:artwork_keywords)
                                        .where(artwork_keywords: { keyword_id: keyword_id })
                                        .distinct
  }

  scope :published, -> { where(published: true) }


  # def price(num)
  #   @view.number_to_currency(num)
  # end

  def set_as_published!
    self.update published: true
  end

  def remove_published!
    self.update published: false
  end

  def total_amount
    self.feature_sets.exists? ? self.feature_sets.map{ |f_s| f_s.pieces_available }.sum : 1
  end
end
