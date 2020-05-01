# frozen_string_literal: true

require "validators/email_validator"

class Order < ApplicationRecord
  enum state: %i[draft ordered info_needed artwork_in_creation sent complaint]

  has_many :order_items, inverse_of: :order
  has_many :feature_sets, through: :order_items

  validates :permalink, uniqueness: true, unless: :state_draft?

  validates :first_name, presence: true, unless: :state_draft?
  validates :last_name, presence: true, unless: :state_draft?
  validates :city, presence: true, unless: :state_draft?
  validates :zip_code, presence: true, unless: :state_draft?
  validates :house_number, presence: true, unless: :state_draft?
  validates :street, presence: true, unless: :state_draft?
  validates :email, presence: true, email: true, unless: :state_draft?

  before_save :generate_permalink, if: :changes_to_ordered?
  before_save :generate_payment_reference, if: :changes_to_ordered?

  private

  def generate_permalink
    self.permalink = Digest::SHA1.hexdigest(
      self.last_name + self.email + Time.zone.now.to_f.to_s + Kernel.rand(999_999).to_s
    )
  end

  def generate_payment_reference
    total_orders = "%02d" % Order.count
    article_id = "%02d" % (self.order_items.exists? ? self.order_items[0].artwork.id : rand(0..99))
    zip_code = "%04d" % (self.zip_code.to_i.digits.join.to_i + self.house_number.to_i)
    random = "%01d" % rand(0..9)
    o_i_count = "%01d" % self.order_items.count
    self.payment_reference = PaymentReference.create(total_orders + article_id + zip_code + random + o_i_count).to_s
  end

  def state_draft?
    state == "draft"
  end

  def changes_to_ordered?
    # CORRIGEREN NA AFWERKEN DEFINITIEF BESTELLEN!
    self.previous_changes[:state].present?  
  end
end
