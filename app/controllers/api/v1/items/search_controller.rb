class Api::V1::Items::SearchController < ApplicationController
  def search_items
    name = params[:name]
    items = Item.where("name ILIKE ?", "%#{name}%")
    render json: ItemSerializer.new(items)
  end
end