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

  describe 'Merchant Search' do
    context 'happy path endpoint' do
      it 'returns a list of merchants matching the search criteria' do
        create(:merchant, name: 'John Doe')
        create(:merchant, name: 'Jane Smith')
        create(:merchant, name: 'Robert Jones')

        get '/api/v1/merchants/search?name=John'

        expect(response).to be_successful
        expect(response.status).to eq(200)

        data = JSON.parse(response.body, symbolize_names: true)

        merchant_data = data[:data]

        expect(data[:data].count).to eq(1)

        merchant = merchant_data.first

        expect(merchant).to have_key(:id)
        expect(merchant[:id]).to be_a String

        expect(merchant[:attributes][:name]).to eq('John Doe')
        expect(merchant[:attributes][:name]).to be_a String
      end
      

      it 'can get merchants for case insensitive name search' do
        create(:merchant, name: 'John Doe')
        create(:merchant, name: 'Jane Smith')
        create(:merchant, name: 'Robert Jones')

        get '/api/v1/merchants/search?name=john'

        data = JSON.parse(response.body, symbolize_names: true)

        merchant = data[:data].first

        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(merchant).to have_key(:id)
        expect(merchant[:attributes][:name]).to eq('John Doe')
        expect(merchant[:attributes][:name]).to be_a String
      end

      it 'can find all items based on searched merchant' do
        merchant = Merchant.create!(name: 'John Doe')
        item_1 = Item.create!(name: 'Item 1', merchant_id: merchant.id)
        item_2 = Item.create!(name: 'Item 2', merchant_id: merchant.id)

        get '/api/v1/merchants/search?name=John'

        data = JSON.parse(response.body, symbolize_names: true)
        merchant_data = data[:data].first

        relationships = merchant_data[:relationships]
        items_data = relationships[:items][:data]

        expect(items_data.count).to eq(2)

        items_data.each do |item|
          expect(item).to have_key(:id)
          expect(item).to have_key(:type)
          expect(item[:type]).to eq('item')
          expect(item[:id]).to be_a String
        end
      end
    end

    context 'sad path endpoint' do
      it 'returns an error if no search criteria is provided' do
        create(:merchant, name: 'John Doe')
        create(:merchant, name: 'Jane Smith')
        create(:merchant, name: 'Robert Jones')

        get '/api/v1/merchants/search?name=Sam'

        data = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(data[:data]).to eq([])
        expect(status).to eq(200)
      end
    end
  end
end
