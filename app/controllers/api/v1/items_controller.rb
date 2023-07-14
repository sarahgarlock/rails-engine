class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    item = Item.find_by(id: params[:id])

    if item.nil?
      render json: { error: "Couldn't find Item with 'id'=#{params[:id]}" }, status: :not_found
    else
      render json: ItemSerializer.new(item)
    end
  end

  def create
    item = Item.new(item_params)
    if item.save
      render json: ItemSerializer.new(item), status: :created
    else
      render json: { error: item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    item = Item.update(params[:id], item_params)
    if item.save
      render json: ItemSerializer.new(Item.update(params[:id], item_params))
    else
      render :status => 400
    end
  end

  def destroy
    render json: ItemSerializer.new(Item.destroy(params[:id]))
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
