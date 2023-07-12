require 'rails_helper'

RSpec.describe 'Items API' do
  it 'sends a list of all items' do
    create_list(:item, 10)

    get "/api/v1/items"

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(10)
    expect(response.status).to eq(200)

    expect(items[:data].first).to have_key(:id)
    expect(items[:data].first[:id]).to be_a String

    attributes = items[:data].first[:attributes]

    expect(attributes).to have_key(:name)
    expect(attributes[:name]).to be_a String
    expect(attributes).to have_key(:description)
    expect(attributes[:description]).to be_a String
    expect(attributes).to have_key(:unit_price)
    expect(attributes[:unit_price]).to be_a Float
    expect(attributes).to have_key(:merchant_id)
    expect(attributes[:merchant_id]).to be_an Integer
  end

  it 'can get one item by its id' do
    create_list(:item, 3)

    get "/api/v1/items/#{Item.first.id}"

    expect(response).to be_successful

    item = JSON.parse(response.body, symbolize_names: true)

    expect(item[:data]).to have_key(:id)
    expect(item[:data][:id]).to be_a String

    attributes = item[:data][:attributes]

    expect(attributes).to have_key(:name)
    expect(attributes[:name]).to be_a String
    expect(attributes).to have_key(:description)
    expect(attributes[:description]).to be_a String
    expect(attributes).to have_key(:unit_price)
    expect(attributes[:unit_price]).to be_a Float
    expect(attributes).to have_key(:merchant_id)
    expect(attributes[:merchant_id]).to be_an Integer
  end

  it 'can create a new item' do
    create(:item)

    item_params = {
      name: 'New Item',
      description: 'New Item Description',
      unit_price: 1.99,
      merchant_id: Merchant.first.id
    }

    headers = { 'CONTENT_TYPE' => 'application/json' }

    post '/api/v1/items', headers: headers, params: JSON.generate(item_params)
    created_item = Item.last

    expect(response).to be_successful

    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.name).to be_a String
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.description).to be_a String
    expect(created_item.unit_price).to eq(item_params[:unit_price])
    expect(created_item.unit_price).to be_a Float
    expect(created_item.merchant_id).to eq(item_params[:merchant_id])
    expect(created_item.merchant_id).to be_an Integer

    expect(response.status).to eq(201)
    expect(Item.count).to eq(2)
  end

  it 'can destroy an item' do
    item = create(:item)

    expect { delete "/api/v1/items/#{item.id}" }.to change(Item, :count).by(-1)

    expect(response).to be_successful
    expect(Item.count).to eq(0)
    expect { Item.find(item.id) }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'can update an item' do
    id = create(:item).id
    previous_name = Item.last.name
    item_params = { name: 'Updated Item Name' }
    headers = { 'CONTENT_TYPE' => 'application/json' }

    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({ item: item_params })
    item = Item.find_by(id: id)

    expect(response).to be_successful
    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq('Updated Item Name')
  end

  # xit 'returns 400 or 404 for a bad merchant ID' do

  #   get "/api/v1/merchants/9999/items"

  #   expect(response).to have_http_status(:not_found).or have_http_status(:bad_request)

  #   data = JSON.parse(response.body, symbolize_names: true)

  #   expect(data).to have_key(:error)
  #   expect(data[:error]).to eq("Couldn't find Merchant with 'id'=99999")
  # end

  it 'can get an items merchant' do
    
  end
end