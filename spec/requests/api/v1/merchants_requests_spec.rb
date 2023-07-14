require 'rails_helper'

describe "Merchants API" do
  it "sends a list of all merchants" do
    create_list(:merchant, 3)

    get "/api/v1/merchants"

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(3)
    merchants[:data].each do |merchant|

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a String

      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an String
    end
  end

  it 'can get one merchant by its id' do
    merchants = create_list(:merchant, 3)
    merchant_1 = merchants.first

    get "/api/v1/merchants/#{merchant_1.id}"

    expect(response).to be_successful
    expect(response.status).to eq(200)

    data = JSON.parse(response.body, symbolize_names: true)
    merchant_data = data[:data]

    expect(data.count).to eq(1)

    expect(merchant_data).to have_key(:id)
    expect(merchant_data[:attributes][:name]).to be_a String
  end

    it 'returns 400 or 404 for a bad merchant ID' do

    get "/api/v1/merchants/99999/items"

    expect(response).to have_http_status(:not_found).or have_http_status(:bad_request)

    data = JSON.parse(response.body, symbolize_names: true)

    expect(data).to have_key(:error)
    expect(data[:error]).to eq("Couldn't find Merchant with 'id'=99999")
  end
end