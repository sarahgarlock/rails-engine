class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    render json: MerchantSerializer.new(Merchant.find(params[:id]))
  end

  def find_merchant
    if params[:name] == nil || params[:name] == ''
      render(status: 404, json: { error: 'Merchant not found' } )
    elsif Merchant.find_name(params[:name]) == []
      render json: MerchantSerializer.new(Merchant.new)
    else 
      render json: MerchantSerializer.new(Merchant.find_name(params[:name]))
    end
  end
end

