# frozen_string_literal: true

class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :validatable

  has_many :artworks, inverse_of: :admin_user
  has_many :answer_remarks, inverse_of: :admin_user,  dependent: :destroy

  validates :email, presence: true
end
