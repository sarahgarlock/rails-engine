class Api::V1::Merchants::ItemsController < ApplicationController
  def index
    merchant = Merchant.find_by(id: params[:merchant_id])

    if merchant.nil?
      render json: { error: "Couldn't find Merchant with 'id'=#{params[:merchant_id]}" }, status: :not_found
    else
      items = merchant.items
      render json: ItemSerializer.new(items)
    end
  end
end 