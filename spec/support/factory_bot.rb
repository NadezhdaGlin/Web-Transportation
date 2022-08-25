FactoryBot.define do
  factory :cargo do
    name {Faker::Name.first_name}
    surname {Faker::Name.last_name}
    middle_name {Faker::Name.middle_name}
    phone {Faker::PhoneNumber.phone_number}
    email {Faker::Internet.email}
    weight {9.5}
    length {2}
    width {3}
    height {4}
    origins {"Krasnodar"}
    destinations {'Moscow'}
    distance {1351.0}
    price {1351}
  end
end
