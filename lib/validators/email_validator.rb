# frozen_string_literal: true

class EmailValidator < ActiveModel::EachValidator
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  def validate_each(record, attribute, value)
    value.to_s.split(",").map(&:strip).each do |mail|
      unless mail =~ VALID_EMAIL_REGEX
        record.errors[attribute] << (options[:message] || "#{mail} is geen e-mail")
      end
    end
  end
end
