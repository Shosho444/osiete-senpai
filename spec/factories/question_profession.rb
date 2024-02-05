FactoryBot.define do
  factory :question_profession do
    association :question
    association :profession
  end
end
