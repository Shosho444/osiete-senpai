FactoryBot.define do
  factory :question do
    sequence(:subject) { |n| "私は生まれて#{n}年目です" }
    body { 'あなたは何歳でしょうか？' }
    keyword { '生まれて' }
    deadline { Time.current.beginning_of_day.days_since(2).change(hour: 8) }
    association :user

    after(:create) do |question|
      create_list(:question_profession, 1, question:, profession: create(:profession))
    end
  end
end
