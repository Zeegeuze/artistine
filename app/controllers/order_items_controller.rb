class OrderItemsController < ApplicationController

  def create
    @feature_set = FeatureSet.find params[:feature_set_id]

    @order = current_order
 
    @order_item = @order.order_items.new
    @order_item.feature_set = @feature_set
    @order_item.qty = @order_item.feature_set.sold_per
    @order_item.price = @order_item.feature_set.price
    @order_item.color = @order_item.feature_set.color
    @order_item.material = @order_item.feature_set.material
    @order_item.size = @order_item.feature_set.size
    @order.save!

    session[:order_id] = @order.id
    
    redirect_back fallback_location: admin_artwork_path(@feature_set.artwork.id), notice: "Het kunstwerk werd toegevoegd aan je betaalmandje."
  end
end