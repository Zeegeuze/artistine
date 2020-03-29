# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswerRemark, type: :model do
  it "is valid" do
    expect(create(:answer_remark)).to be_valid
  end

  it "must have an admin_user" do
    expect(build(:answer_remark, admin_user: nil)).to have(1).error_on(:admin_user)
  end

  it "must have a remark" do
    expect(build(:answer_remark, remark: nil)).to have(1).error_on(:remark)
  end   
end
