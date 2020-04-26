# frozen_string_literal: true

require "validators/email_validator"

class Order < ApplicationRecord
  has_many :order_items, inverse_of: :order

  validates :permalink, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :city, presence: true
  validates :zip_code, presence: true
  validates :house_number, presence: true
  validates :street, presence: true
  validates :email, presence: true, email: true

  before_create :generate_permalink
  before_create :generate_payment_reference

  def generate_permalink
    self.permalink = Digest::SHA1.hexdigest(
      self.last_name + self.email + Time.now.to_f.to_s + Kernel.rand(999_999).to_s
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
end
