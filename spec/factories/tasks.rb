FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "rspec_test_#{n}" }
    content { "content" }
    status   { 'todo' }
    association :user
  end
end
