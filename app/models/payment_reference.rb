# frozen_string_literal: true

class PaymentReference
  include ActiveModel::Validations

  attr_reader :first_ten_digits, :checksum

  validates! :first_ten_digits, length: { is: 10 }
  validates! :checksum, length: { is: 2 }
  validates! :checksum, numericality: { greater_than: 0 }

  def initialize(number)
    @first_ten_digits = number.to_s[0..9]
    @checksum = number.to_s[10..-1]
  end

  def to_s(add_plusses: true)
    ref = first_ten_digits[0..2] + "/" +
          first_ten_digits[3..6] + "/" +
          first_ten_digits[7..-1] + checksum

    if add_plusses
      ref = "+++#{ref}+++"
    end

    ref
  end

  def self.parse(string)
    ogm = new(string.scan(/\d/).join(""))
    ogm.valid?
    ogm
  end

  def self.create(number)
    first_ten_digits = number.to_s
    checksum = calc_checksum(number)
    parse(first_ten_digits + checksum)
  end

  def self.try(payment_reference)
    begin
      parse(payment_reference).to_s
    rescue ActiveModel::StrictValidationFailed
      payment_reference
    end
  end

  def self.calc_checksum(number)
    cs = number.to_i.modulo(97)
    cs = 97 if cs == 0
    return "%02d" % cs
  end
end
