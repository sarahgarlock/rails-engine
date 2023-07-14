class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices

  def self.find_name(search_params)
    where('name ILIKE ?', "%#{search_params}%").order(name: :asc)
  end
end