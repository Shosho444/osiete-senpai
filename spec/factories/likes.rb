FactoryBot.define do
  factory :like do
    association :user
    trait :question do
      likeable_type { 'Question' }
      likeable_id { create(:question).id }
    end
    trait :answer do
      likeable_type { 'Answer' }
      likeable_id { create(:answer).id }
    end
  end
end
