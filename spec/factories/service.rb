FactoryBot.define do
  factory :service do
    sequence(:name) { |n| "#{Faker::Company.name} #{n}" }

    description { Faker::Lorem.paragraph }
    url { Faker::Internet.url }
    after(:create) do |service|
      create(:location, services: [service])
    end
    organisation
  end
end
