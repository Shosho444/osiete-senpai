FactoryBot.define do
  factory :question_form do
    subject { '秋がとても好きです' }
    body { 'あなたはどの季節が好きですか？' }
    deadline { Time.current.midnight.since(2.days) }
    profession_ids { %w[1 2] }
    user_id { '1' }
  end
end
