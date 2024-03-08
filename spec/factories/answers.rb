FactoryBot.define do
  factory :answer do
    sequence(:must) { |n| "#{n}番目の必要項目" }
    sequence(:want) { |n| "#{n}番目の追加項目" }
    sequence(:body) { |n| "#{n}番目の本文" }
    association :user
    association :question
  end
end
