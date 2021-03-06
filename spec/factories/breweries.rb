FactoryBot.define do
  factory :brewery do
    name { Faker::Company.name }
    address { Faker::Address.full_address }
    contact_name { Faker::Name.name }
    phone { Faker::PhoneNumber.phone_number }
    email { Faker::Internet.email }
    website { Faker::Internet.url }
    logo_image { File.new(File.join(Rails.root, 'public/test.jpeg')) }
    uid { Faker::Internet.password }
  end
end
