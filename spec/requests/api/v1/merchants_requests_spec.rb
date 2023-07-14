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

    # binding.pry
    expect(data.count).to eq(1)

    expect(data[:data]).to have_key(:id)
    expect(data[:data][:attributes][:name]).to be_a String
  end
end