# frozen_string_literal: true

FactoryBot.define do
  factory :answer_remark do
    admin_user { AdminUser.first || create(:admin_user) }
    remark { Remark.first || create(:remark) }
    body { "Vlammende antwoord" }
  end
end
