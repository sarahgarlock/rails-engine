class Api::V1::Merchants::SearchController < ApplicationController
  def search
    name = params[:name]
    merchants = Merchant.where("name ILIKE ?", "%#{name}%")
    render json: MerchantSerializer.new(merchants)
  end
end