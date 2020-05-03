class OrdersController < ApplicationController
  def new

  end
  
  # def create
  #   @order = Order.new(permitted_params[:order])
  #   @order.session_id = session[:session_id]
  #   @order.save!

  #   transaction_notice = "" #"De bestelling werd correct geplaatst."
  #   create!(notice: transaction_notice) { redirect_back fallback_location: default_fallback_location }
  # end
  
end
