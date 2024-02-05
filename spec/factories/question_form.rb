FactoryBot.define do
  factory :question_form do
    subject { '秋がとても好きです' }
    body { 'あなたはどの季節が好きですか？' }
    deadline_date { Time.zone.today.days_since(2) }
    deadline_time { '1' }
    profession_ids { %w[1 2] }
    user_id { '1' }
  end
end
