# frozen_string_literal: true

require "rails_helper"

feature "create order" do
  let(:artwork) { create(:artwork, name: "Super skoon kunstwerkje", published: true) }
  let!(:feature_set) { create(:feature_set, artwork: artwork, price: 15, sold_per: 2) }

  before do
    visit "/artwork_details/#{artwork.id}"

    click_button "Koop"

    order = Order.first
    order_item = OrderItem.first
  end
 
  it "created an order" do
    expect(Order.count).to eq 1
  end

  it "created an order_item" do
    expect(OrderItem.count).to eq 1
  end

  it "sets status to draft" do
    order = Order.first

    expect(order.state).to eq "draft"
  end

  it "sets sets the correct date from the feature_set" do
    order_item = OrderItem.first

    expect(order_item.price).to eq 15
    expect(order_item.qty).to eq 2
  end

  it "doesn't set the permalink" do
    order = Order.first

    expect(order.permalink).to be_nil
  end

  it "doesn't set the payment_reference" do
    order = Order.first

    expect(order.payment_reference).to be_nil
  end

  it "doesn't create two orders if feature_set is added twice" do
    click_button "Koop"

    expect(Order.count).to eq 1
  end

  it "allows to add two feature_sets" do
    feature_set_2 = create(:feature_set, artwork: artwork, price: 17, sold_per: 5)

    visit "/artwork_details/#{artwork.id}"

    within ".feature_set_#{feature_set_2.id}" do
      click_button "Koop"
    end

    expect(Order.count).to eq 1
    expect(OrderItem.count).to eq 2
  end
end