class QuestionProfession < ApplicationRecord
  belongs_to :question
  belongs_to :profession
end
