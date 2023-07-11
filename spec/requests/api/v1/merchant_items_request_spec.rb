require 'rails_helper'

RSpec.describe 'Merchant Items API' do
  it 'sends a list of all items for a merchant' do

    merchant_id = create(:merchant).id
    create_list(:item, 3, merchant_id: merchant_id)
    
    get "/api/v1/merchants/#{merchant_id}/items"

    items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(response.status).to eq(200)

    expect(items[:data].count).to eq(3)

    expect(items[:data].first).to have_key(:id)
    expect(items[:data].first[:id]).to be_a String

    expect(items[:data].first[:attributes]).to have_key(:name)
    expect(items[:data].first[:attributes][:name]).to be_a String

    expect(items[:data].first[:attributes]).to have_key(:description)
    expect(items[:data].first[:attributes][:description]).to be_a String

    expect(items[:data].first[:attributes]).to have_key(:unit_price)
    expect(items[:data].first[:attributes][:unit_price]).to be_a Float

    expect(items[:data].first[:attributes]).to have_key(:merchant_id)
    expect(items[:data].first[:attributes][:merchant_id]).to be_a Integer
  end
end