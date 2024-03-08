class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question
  has_many :likes, as: :likeable, dependent: :destroy

  with_options length: { maximum: 10_666 } do
    validates :must, presence: true
    validates :want, presence: true
    validates :body, length: { minimum: 5 }
  end
end
