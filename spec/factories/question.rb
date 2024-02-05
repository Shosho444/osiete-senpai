FactoryBot.define do
  factory :question do
    subject { '秋がとても好きです' }
    body { 'あなたはどの季節が好きですか？' }
    keyword { '秋' }
    deadline { Time.current.beginning_of_day.days_since(2) }
    sequence(:user_id, &:to_s)

    after(:create) do |question|
      create_list(:question_profession, 1, question:, profession: create(:profession))
    end
  end
end
