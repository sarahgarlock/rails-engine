class Api::V1::Items::MerchantController < ApplicationController
  def index
    render json: MerchantSerializer.new(Item.find(params[:item_id]).merchant)
  end

  def show
    render json: MerchantSerializer.new(Item.find(params[:id]).merchant)
  end

  def search_merchant
    name = params[:name]
    merchants = Merchant.where("name ILIKE ?", "%#{name}%")
    render json: MerchantSerializer.new(merchants)
  end
end
