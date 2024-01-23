class Question < ApplicationRecord
  belongs_to :user
  has_many :question_professions, dependent: :destroy
  has_many :professions, through: :question_professions
  accepts_nested_attributes_for :question_professions

  validates :subject, length: { maximum: 255 }, presence: true
  validates :keyword, length: { maximum: 255 }, presence: true
  validates :body, length: { maximum: 65_535 }, presence: true
  validate :finish_check

  def finish_check
    return if deadline.blank?

    if Time.current.hour < 12
      errors.add(:deadline, 'は明日以降の時間を選択してください') if deadline < Time.current.midnight.tomorrow
    elsif deadline < Time.current.midnight.since(2.days)
      errors.add(:deadline, 'は明後日以降の時間を選択してください')
    end
  end
end
