FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "rspec#{n}@example.com" }
    password { 'rspec' }
    password_confirmation { 'rspec' }
  end
end
