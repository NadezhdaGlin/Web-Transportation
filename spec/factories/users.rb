# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 123_456 }
    role { 'orgadmin' }
    organization_id { (create :organization).id }
  end
end
