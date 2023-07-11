FactoryBot.define do
  factory :merchant do
    name { Faker::Sports::Basketball.player }
  end
end