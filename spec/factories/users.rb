FactoryBot.define do
  factory :user do
    name { 'らんてくん' }
    sequence(:email) { |n| "runteq_#{n}@example.com" }
    sequence(:email_confirmation) { |n| "runteq_#{n}@example.com" }
    password { 'test12' }
    password_confirmation { 'test12' }
  end
end
