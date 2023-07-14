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

# def find_merchant
#   merchant_name = Merchant.find_name(params[:name]).first
    
#   if Merchant.find_name(params[:name]) ==[]
#     render json: MerchantSerializer.new(Merchant.new)
#   elsif merchant_name.present?
#     render json: MerchantSerializer.new(merchant_name)
#   end
# end